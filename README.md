# ubuntu-dev-setup
A comprehensive shell script to automate the installation of essential development tools on Ubuntu. Includes version control, IDEs, cloud tools, container platforms, programming languages, and modern development utilities. Simplify your development environment setup with a single command.


# Ubuntu Dev Setup Script

This repository contains a shell script to automate the installation of essential development tools on Ubuntu. The script installs the following tools with a single command:

## Development Essentials
- **Build Essentials** - gcc, g++, make and common build tools
- **Git** - Version control system
- **GitHub CLI (gh)** - GitHub command-line tool
- **Visual Studio Code** - Modern code editor
- **Vim/Nano** - Terminal text editors

## Programming Languages & Runtimes
- **Python 3 & pip** - Python runtime and package manager
- **Node.js LTS & npm** - JavaScript runtime and package manager
- **Yarn** - Alternative package manager for Node.js

## Collaboration & API Testing
- **Postman** - API development and testing
- **Microsoft Teams** - Team collaboration

## Database Tools
- **pgAdmin** - PostgreSQL database management

## Container & Orchestration
- **Docker** - Container platform
- **Docker Compose (plugin)** - Multi-container Docker applications
- **kubectl** - Kubernetes command-line tool
- **k9s** - Kubernetes CLI manager
- **Helm** - Kubernetes package manager

## Cloud Tools
- **AWS CLI v2** - Amazon Web Services command-line interface
- **Azure CLI** - Microsoft Azure command-line interface
- **Google Cloud SDK** - Google Cloud Platform tools

## Infrastructure as Code
- **Terraform** - Infrastructure provisioning tool

## Terminal & Shell Enhancement
- **Zsh** - Modern shell
- **Oh My Zsh** - Zsh configuration framework
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Syntax highlighting in terminal

## Development Utilities
- **jq** - JSON processor
- **yq** - YAML processor
- **htop** - Interactive process viewer
- **tree** - Directory structure viewer
- **tmux** - Terminal multiplexer
- **curl/wget** - Data transfer tools
- **unzip/zip/tar/gzip** - Archive tools
- **net-tools/dnsutils** - Network utilities

## Requirements

- Ubuntu 20.04 LTS or later
- Internet connection
- Sudo privileges

## Usage

1. Clone the repository:
```bash
git clone https://github.com/oyekamal/ubuntu-dev-setup.git
cd ubuntu-dev-setup
```

2. Make the script executable:
```bash
chmod +x install_tools.sh
```

3. Run the script:
```bash
./install_tools.sh
```

4. Follow the on-screen instructions. The script will:
   - Update system packages
   - Install all development tools
   - Configure necessary permissions
   - Display installation summary

5. After installation completes:
   - **Log out and log back in** for Docker group changes to take effect
   - Optionally set Zsh as default shell: `chsh -s $(which zsh)`

## Features

- **Colored output** for better readability
- **Error handling** with exit on failure
- **Skip checks** to avoid reinstalling existing tools
- **Progress indicators** for each installation step
- **Installation summary** at the end
- **Clean up** to remove unnecessary packages

## Notes

- The script uses official repositories and package managers for stability
- Docker Compose is installed as a Docker plugin (v2), which is the modern approach
- All cloud CLIs (AWS, Azure, GCP) are installed for maximum flexibility
- Zsh with Oh My Zsh provides an enhanced terminal experience
- The script is idempotent - safe to run multiple times
- Architecture detection supports both x86_64 and ARM64 systems
- Some installations (Node.js, Helm, Azure CLI, Oh My Zsh) use piped curl commands for convenience. These execute official installation scripts from trusted sources over HTTPS.

## Security Considerations

While this script prioritizes convenience, be aware that:
- Some tools are installed via piped curl commands that execute remote scripts
- All sources use HTTPS for secure connections
- Scripts are from official, trusted sources (NodeSource, Microsoft, HashiCorp, etc.)
- For maximum security in production environments, consider downloading and reviewing scripts before execution

## Customization

You can comment out sections in `install_tools.sh` if you don't need certain tools. Each section is clearly labeled and independent.

## Troubleshooting

If you encounter any issues:

1. Ensure your Ubuntu version is supported (20.04+)
2. Check your internet connection
3. Verify you have sudo privileges
4. Review the error messages - the script uses colored output to highlight issues
5. Try running `sudo apt-get update` manually before running the script

## License

This project is licensed under the MIT License - see the LICENSE file for details.