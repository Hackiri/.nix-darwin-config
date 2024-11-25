# Nix Darwin Configuration

Nix system configuration for macOS using nix-darwin and Home Manager, providing a declarative and reproducible user environment.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Customization Guide](#customization-guide)
- [Maintenance](#maintenance)

## Overview

This repository contains a complete nix-darwin configuration that manages both system-level settings and user environments on macOS. It combines nix-darwin for system configuration with Home Manager for user environment management, creating a fully reproducible and declarative setup.

## Features

### Core Components
- 🚀 **Declarative macOS Configuration**
  - System-wide settings management
  - Automated system updates
  - Homebrew integration via `nix-homebrew`
  - Content-addressed derivations support
  
- 🏠 **User Environment Management**
  - Complete home directory configuration
  - XDG base directory support
  - Dotfiles management
  - Application settings synchronization

- 📦 **Package Management**
  - Nix Flakes for reproducible builds
  - Automatic garbage collection (weekly)
  - Storage optimization
  - Binary cache configuration
  - Trusted user management

### Development Environment
- **Neovim Configuration**
  - LSP support for multiple languages
  - Modern UI with Tokyo Night theme
  - Efficient code navigation
  - Integrated debugging
  - Custom keybindings
  - Telescope fuzzy finding
  - Git integration
  - Tree-sitter syntax highlighting

- **Terminal Environment**
  - WezTerm with GPU acceleration and multiplexing
  - Custom font configuration
  - Zsh with extensive customization
  - Tmux integration
  - Starship prompt
  - Directory jumping with zoxide
  - Modern CLI tools (bat, eza, ripgrep)

- **Programming Support**
  - Multiple language environments
    - Python with pip and virtualenv
    - Node.js and npm
    - Rust with cargo
    - Go development environment
  - Build tools and debuggers
    - GCC and LLDB
    - CMake and Ninja
    - pkg-config and autotools
  - Container management
  - Development shells with direnv

### System Features
- **Security**
  - Touch ID for sudo authentication
  - Secure SSH configuration
  - Git-crypt for secrets management
  - Keychain integration

- **Performance**
  - Automatic garbage collection
  - Weekly storage optimization
  - Parallel builds configuration
  - Binary caches setup

- **Maintenance**
  - Automated cleanup tasks
  - System health monitoring
  - Pre-commit hooks
  - Nix store optimization

### Additional Tools
- **CLI Utilities**
  - Modern replacements for traditional tools
  - Git workflow enhancements
  - File management utilities
  - System monitoring tools

- **Quality Assurance**
  - Pre-commit hooks for code quality
  - Nix code formatting with alejandra
  - Dead code elimination with deadnix
  - Static analysis with statix

## System Architecture

### Directory Structure
```bash
.nix-darwin-config/
├── flake.nix                # System entry point
├── home-manager/           # User configuration
├── modules/                # Configuration modules
│   ├── home-manager/      # User-specific settings
│   │   ├── devshell/     # Development environment
│   │   ├── neovim/       # Editor configuration
│   │   └── terminal/     # Terminal setup
│   └── nix-darwin/       # System-wide settings
├── nixos/                 # Host configurations
└── overlays/             # Package modifications
```

### Key Components

#### System Configuration
```nix
# System-wide settings in configuration.nix
{
  system = {
    defaults = {
      dock = {
        autohide = true;
        static-only = true;
      };
      finder.AppleShowAllExtensions = true;
    };
  };
}
```

#### Package Management
```nix
# Flake-based configuration
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };
}
```

#### Maintenance
```nix
# Automated garbage collection
nix.gc = {
  automatic = true;
  interval = { Weekday = 0; Hour = 2; Minute = 0; };
  options = "--delete-older-than 30d";
};
```

## Installation

### Prerequisites
- macOS 10.15 or later
- Administrative access
- Internet connection

### Forking and Customization

1. Fork the Repository
```bash
# Fork this repository on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/nix-darwin-config.git ~/.nix-darwin-config
cd ~/.nix-darwin-config
```

2. Customize Your Setup
- **System Configuration**
  - Update `flake.nix` with your system details
  - Modify `nixos/hosts/` to match your hostname
  - Adjust `nixConfig` settings as needed

- **User Environment**
  - Update `home-manager/home.nix` with your user preferences
  - Customize `modules/home-manager/` for your tools and apps
  - Modify `modules/nix-darwin/` for system-wide settings

- **Optional Components**
  - Remove unused modules from `modules/`
  - Add your own modules for specific needs
  - Customize the directory structure to your preference

3. Version Control
```bash
# Initialize your own git repository
git remote set-url origin https://github.com/YOUR_USERNAME/nix-darwin-config.git
git add .
git commit -m "Initial customization"
git push -u origin main
```

### Setup Process

1. Install Nix
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Enable Flakes
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. Clone Configuration
```bash
git clone https://github.com/YOUR_USERNAME/nix-darwin-config.git ~/.nix-darwin-config
```

4. Customize Configuration
- Update hostname in `flake.nix`
- Modify user settings in `configuration.nix`
- Adjust feature flags as needed

5. Apply Configuration
```bash
cd ~/.nix-darwin-config
darwin-rebuild switch --flake .
```

## Configuration

### System Settings
- **Security**
  - Touch ID authentication
  - SSH with keychain
  - Secure defaults

- **UI/UX**
  - Dock configuration
  - Finder preferences
  - Screenshot settings

- **Development**
  - Programming languages
  - Build tools
  - Container support

### User Environment
- **Shell**: Customized Zsh environment
- **Editor**: Neovim with LSP
- **Terminal**: GPU-accelerated WezTerm
- **Tools**: Development utilities

## Customization Guide

### Essential Customization

1. **System Identity** (required)
   ```bash
   flake.nix                # Core system configuration
   ```
   ```nix
   # Change "WMs-MacBook-Pro" to your hostname
   darwinConfigurations = {
     "YOUR-HOSTNAME" = nix-darwin.lib.darwinSystem {
       # ...
     };
   };
   ```
   - Update system hostname
   - Modify inputs and dependencies as needed
   - Add or remove modules based on your needs

2. **Host Configuration** (required)
   ```bash
   nixos/hosts/
   ├── your-hostname/           # Rename to match your hostname (lowercase)
   │   └── configuration.nix    # Main system configuration
   ```
   ```nix
   # In configuration.nix, update username and settings
   nix.settings.trusted-users = ["root" "your-username"];
   ```
   - Copy and rename the example host directory to match your hostname
   - Edit `configuration.nix` to set system-wide preferences
   - Configure system packages, services, and security settings

3. **User Configuration** (required)
   ```bash
   home-manager/home.nix    # Personal user configuration
   ```
   ```nix
   # Update these with your details
   home.username = "your-username";
   home.homeDirectory = "/Users/your-username";
   ```
   - Update username and home directory path
   - Customize user packages and environment variables
   - Configure personal development tools

4. **Git Configuration** (recommended)
   ```bash
   modules/home-manager/terminal/zsh/default.nix
   ```
   ```nix
   programs.git = {
     userName = "Your Name";
     userEmail = "your.email@example.com";
     signing = {
       key = "your-signing-key";
       signByDefault = true;
     };
   };
   ```

5. **Personal Preferences** (optional)
   ```bash
   # Shell Configuration
   modules/home-manager/terminal/zsh/aliases.nix  # Custom aliases
   
   # Terminal Configuration
   modules/home-manager/terminal/wezterm/main_config.lua
   
   # Editor Configuration
   modules/home-manager/neovim/lua/config/options.lua
   ```

6. **Secret Management** (if needed)
   ```bash
   secrets/
   └── secrets.nix         # Encrypted secrets (using git-crypt)
   ```
   - Initialize git-crypt for sensitive data
   - Add secrets using the provided structure
   - Never commit unencrypted secrets

Remember to rebuild your system after making these changes:
```bash
darwin-rebuild switch --flake .
```

### Module Customization

1. **Terminal Setup**
   ```bash
   modules/home-manager/terminal/
   ├── wezterm/              # Terminal emulator config
   │   ├── default.nix
   │   └── main_config.lua   # WezTerm specific settings
   └── zsh/                  # Shell configuration
       ├── default.nix
       └── aliases.nix       # Custom aliases
   ```
   - Customize terminal appearance and behavior
   - Add personal aliases and functions
   - Configure key bindings and plugins

2. **Development Environment**
   ```bash
   modules/home-manager/
   ├── devshell/            # Development environment settings
   └── neovim/              # Editor configuration
       ├── default.nix
       └── lua/             # Neovim lua configurations
   ```
   - Set up language-specific development environments
   - Configure editor plugins and keymaps
   - Add custom development tools

3. **System Modules**
   ```bash
   modules/nix-darwin/      # macOS specific settings
   └── default.nix
   ```
   - Configure macOS system preferences
   - Set up system-wide services
   - Add custom system modifications

### Adding New Features

1. **Creating Custom Modules**
   ```bash
   modules/home-manager/
   └── your-module/
       ├── default.nix      # Module configuration
       └── config/          # Additional config files
   ```
   - Create new modules for specific tools or workflows
   - Follow the existing module structure
   - Import your module in `home.nix`

2. **Secret Management**
   ```bash
   secrets/
   └── secrets.nix         # Encrypted secrets (using git-crypt)
   ```
   - Initialize git-crypt for sensitive data
   - Add secrets using the provided structure
   - Never commit unencrypted secrets

### Common Customizations

1. **Adding Packages**
   ```nix
   # home.nix
   home.packages = with pkgs; [
     your-package
     another-package
   ];
   ```

2. **Modifying System Settings**
   ```nix
   # configuration.nix
   system.defaults = {
     dock = {
       autohide = true;
       orientation = "left";
     };
   };
   ```

3. **Creating Development Shells**
   ```nix
   # modules/home-manager/devshell/default.nix
   devShells.${system}.your-project = pkgs.mkShell {
     buildInputs = with pkgs; [
       # Add project-specific packages
     ];
   };
   ```

### Testing Changes

1. Build without applying:
   ```bash
   darwin-rebuild build --flake .
   ```

2. Check configuration:
   ```bash
   nix flake check
   ```

3. Apply changes:
   ```bash
   darwin-rebuild switch --flake .
   ```

## Maintenance

### Regular Updates
```bash
# Update and rebuild
darwin-rebuild switch --flake .

# Update specific inputs
nix flake lock --update-input nixpkgs
```

### System Cleanup
```bash
# Manual garbage collection
nix-collect-garbage -d

# Store optimization
nix store optimise
```

### Monitoring
- Check system status
- Review logs
- Monitor disk usage
- Verify service health

For detailed documentation of specific components, see:
- [DevShell Configuration](modules/home-manager/devshell/README.md)
- [Zsh Configuration](modules/home-manager/terminal/zsh/README.md)
- [Neovim Setup](modules/home-manager/neovim/README.md)
