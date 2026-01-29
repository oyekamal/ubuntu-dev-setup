#!/bin/bash

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_status "Starting Ubuntu Development Environment Setup..."

# Update and upgrade the system
print_status "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential build tools and libraries
print_status "Installing build essentials and common development libraries..."
sudo apt-get install -y \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    wget \
    curl \
    gpg \
    git \
    vim \
    nano \
    unzip \
    zip \
    tar \
    gzip \
    tree \
    htop \
    tmux \
    jq \
    net-tools \
    dnsutils \
    iputils-ping

# Install Git (if not already installed)
print_status "Ensuring Git is installed..."
sudo apt-get install -y git

# Configure Git with recommended settings
git config --global init.defaultBranch main 2>/dev/null || true

# Install Python 3 and pip
print_status "Installing Python 3 and pip..."
sudo apt-get install -y python3 python3-pip python3-venv python3-dev

# Install Node.js via NodeSource repository (LTS version)
print_status "Installing Node.js LTS and npm..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    print_warning "Node.js already installed, skipping..."
fi

# Install yarn package manager
print_status "Installing Yarn package manager..."
if ! command -v yarn &> /dev/null; then
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update -y
    sudo apt-get install -y yarn
else
    print_warning "Yarn already installed, skipping..."
fi

# Install Visual Studio Code
print_status "Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get update -y
    sudo apt-get install -y code
else
    print_warning "VS Code already installed, skipping..."
fi

# Install Postman
print_status "Installing Postman..."
sudo apt-get install -y snapd
if ! snap list | grep -q postman; then
    sudo snap install postman
else
    print_warning "Postman already installed, skipping..."
fi

# Install Microsoft Teams
print_status "Installing Microsoft Teams..."
if ! snap list | grep -q teams-for-linux; then
    sudo snap install teams-for-linux
else
    print_warning "Teams already installed, skipping..."
fi

# Install pgAdmin
print_status "Installing pgAdmin..."
if ! command -v pgadmin4 &> /dev/null; then
    curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
    sudo apt-get update -y
    sudo apt-get install -y pgadmin4-desktop
else
    print_warning "pgAdmin already installed, skipping..."
fi

# Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Remove old versions
    sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    
    # Install Docker using official repository
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker $USER
else
    print_warning "Docker already installed, skipping..."
    # Still try to install Docker Compose plugin if missing
    sudo apt-get install -y docker-compose-plugin 2>/dev/null || true
fi

# Install GitHub CLI
print_status "Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y gh
else
    print_warning "GitHub CLI already installed, skipping..."
fi

# Install kubectl (Kubernetes CLI)
print_status "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update -y
    sudo apt-get install -y kubectl
else
    print_warning "kubectl already installed, skipping..."
fi

# Install Terraform
print_status "Installing Terraform..."
if ! command -v terraform &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update -y
    sudo apt-get install -y terraform
else
    print_warning "Terraform already installed, skipping..."
fi

# Install AWS CLI v2
print_status "Installing AWS CLI v2..."
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
else
    print_warning "AWS CLI already installed, skipping..."
fi

# Install Azure CLI
print_status "Installing Azure CLI..."
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    print_warning "Azure CLI already installed, skipping..."
fi

# Install Google Cloud SDK
print_status "Installing Google Cloud SDK..."
if ! command -v gcloud &> /dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    sudo apt-get update -y
    sudo apt-get install -y google-cloud-cli
else
    print_warning "Google Cloud SDK already installed, skipping..."
fi

# Install k9s (Kubernetes CLI manager)
print_status "Installing k9s..."
if ! command -v k9s &> /dev/null; then
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
    curl -sL "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz" | sudo tar xz -C /usr/local/bin k9s
    sudo chmod +x /usr/local/bin/k9s
else
    print_warning "k9s already installed, skipping..."
fi

# Install Helm (Kubernetes package manager)
print_status "Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    print_warning "Helm already installed, skipping..."
fi

# Install yq (YAML processor)
print_status "Installing yq..."
if ! command -v yq &> /dev/null; then
    YQ_VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
    sudo wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64"
    sudo chmod +x /usr/local/bin/yq
else
    print_warning "yq already installed, skipping..."
fi

# Install zsh and oh-my-zsh (optional but recommended)
print_status "Installing Zsh..."
sudo apt-get install -y zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_warning "Oh My Zsh already installed, skipping..."
fi

# Install useful zsh plugins
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing zsh plugins..."
    
    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
fi

# Clean up
print_status "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Print installation summary
echo ""
print_status "============================================"
print_status "Installation Complete!"
print_status "============================================"
echo ""
print_status "Installed tools:"
echo "  • Build Essentials (gcc, g++, make)"
echo "  • Git (version control)"
echo "  • Python 3 & pip"
echo "  • Node.js LTS & npm"
echo "  • Yarn"
echo "  • Visual Studio Code"
echo "  • Postman"
echo "  • Microsoft Teams"
echo "  • pgAdmin"
echo "  • Docker & Docker Compose (plugin)"
echo "  • GitHub CLI (gh)"
echo "  • kubectl (Kubernetes CLI)"
echo "  • Terraform"
echo "  • AWS CLI v2"
echo "  • Azure CLI"
echo "  • Google Cloud SDK"
echo "  • k9s (Kubernetes manager)"
echo "  • Helm (Kubernetes package manager)"
echo "  • yq (YAML processor)"
echo "  • Zsh & Oh My Zsh"
echo "  • Development utilities (jq, htop, tmux, tree, etc.)"
echo ""
print_warning "IMPORTANT: Please log out and back in for the following changes to take effect:"
echo "  • Docker group membership"
echo "  • Shell changes (if switching to zsh)"
echo ""
print_status "To use zsh as your default shell, run: chsh -s \$(which zsh)"
echo ""
