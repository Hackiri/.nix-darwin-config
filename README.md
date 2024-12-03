# Nix Darwin Configuration

Nix system configuration for macOS using nix-darwin and Home Manager, providing a declarative and reproducible user environment.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Customization Guide](#customization-guide)
- [Maintenance](#maintenance)

## Overview

This repository contains a complete nix-darwin configuration that manages both system-level settings and user environments on macOS. It combines nix-darwin for system configuration with Home Manager for user environment management, creating a fully reproducible and declarative setup.

## Features

### Core Components
- **Declarative macOS Configuration**
  - System-wide settings management
  - Automated system updates
  - Homebrew integration via `nix-homebrew`
  - Content-addressed derivations support
  
- **User Environment Management**
  - Complete home directory configuration
  - XDG base directory support
  - Dotfiles management
  - Application settings synchronization

- **Package Management**
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
  - Custom font configuration
  - Zsh with extensive customization
  - Tmux integration
  - oh-my-zsh with Starship prompt
  - Directory jumping with zoxide
  - Modern CLI tools (bat, eza, ripgrep)

- **Development Tools**
  - Code Quality
    - Pre-commit hooks for automated checks
    - Shellcheck for shell script analysis
    - Alejandra for Nix code formatting
    - Deadnix for dead code detection
    - Statix for static analysis
    - Stylua for Lua formatting
  - Debugging
    - GDB for general debugging
    - LLDB for LLVM-based debugging
  - Infrastructure
    - Terraform for infrastructure as code
    - K9s for Kubernetes cluster management
    - Cilium CLI for network policies
    - Kustomize for Kubernetes manifests
    - Omnictl and Talosctl for cluster operations

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
  - Content-addressed derivations
  - Trusted binary caches:
    - cache.nixos.org
    - nix-community.cachix.org

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
├── home-manager/           # User configuration
├── modules/                # Configuration modules
│   ├── home-manager/      # User-specific settings
│   │   ├── btop/         # System monitor configuration
│   │   │   └── themes/   # Custom themes
│   │   ├── cli/          # Command-line tools
│   │   │   └── zoxide/   # Directory jumper
│   │   ├── devshell/     # Development environment
│   │   ├── emacs/        # Emacs configuration
│   │   ├── neovim/       # Neovim setup
│   │   │   └── lua/      # Lua configurations
│   │   │       ├── config/
│   │   │       └── plugins/
│   │   ├── starship/     # Shell prompt
│   │   ├── terminal/     # Terminal emulators
│   │   │   ├── alacritty/
│   │   │   ├── wezterm/
│   │   │   ├── zellij/   # Terminal multiplexer
│   │   │   └── zsh/      # Shell configuration
│   │   │       ├── lib/
│   │   │       ├── themes/
│   │   │       └── tools/
│   │   └── tmux/         # Terminal multiplexer
│   └── nix-darwin/       # System-wide settings
│       └── nixd/         # Nix language server
├── nixos/                # Host configurations
│   └── hosts/
│       └── wm-macbook-pro/
├── overlays/            # Package modifications
└── pkgs/                # Custom packages
```

### Key Components
- `home-manager`: User-specific configuration
- `nix-darwin`: System-wide settings
- `nixpkgs`: Package collection for nix-darwin
- `home.nix`: User configuration
- `flake.nix`: Nix flake for system configuration and user environment
- `configuration.nix`: Host-specific configuration

## Installation

### Prerequisites
- macOS 10.15 or later
- Administrative access
- Internet connection
- Basic knowledge of Nix/Nix Flakes

### Quick Start

1. Install Nix
```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Enable Flakes
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. Clone Configuration
```bash
git clone https://github.com/YOUR_USERNAME/nix-darwin-config.git ~/.nix-darwin-config
cd ~/.nix-darwin-config
```

4. Initial Setup
```bash
# Build and apply the configuration
darwin-rebuild switch --flake .
```

### Customization Steps

1. Update Personal Information
- Set your username in `flake.nix`
- Configure git settings in `home-manager/home.nix`
- Adjust system settings in `nixos/hosts/wm-macbook-pro/configuration.nix`

2. Choose Your Tools
- Enable/disable modules in `modules/home-manager/default.nix`
- Configure development tools in `modules/home-manager/devshell/`
- Set up editor preferences in `modules/home-manager/neovim/`

3. Apply Changes
```bash
# Test configuration
darwin-rebuild check --flake .

# Apply changes
darwin-rebuild switch --flake .

# Verify with pre-commit hooks
pre-commit run --all-files
```

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
4. pre-commit
   ```bash
   pre-commit run --all-files
   ```

## Maintenance

### System Updates

1. Update Flake Inputs
```bash
nix flake update  # Update all inputs
nix flake lock --update-input nixpkgs  # Update specific input
```

2. Rebuild System
```bash
darwin-rebuild switch --flake .
```

### System Cleanup

1. Garbage Collection
```bash
# Automatic weekly cleanup
nix-collect-garbage -d

# Manual optimization
nix store optimise
```

2. Cache Management
```bash
# Clear old generations
sudo nix-collect-garbage -d

# Remove unused packages
nix store gc
```

### Troubleshooting

1. Common Issues
- Check system logs: `darwin-rebuild switch --show-trace`
- Verify flake inputs: `nix flake metadata`
- Test configuration: `darwin-rebuild check`

2. Recovery Steps
- Rollback to previous generation: `darwin-rebuild switch --rollback`
- Boot to previous generation: `darwin-rebuild boot --rollback`
- Clean build: `darwin-rebuild switch --flake . --recreate-lock-file`

For detailed documentation of specific components, see:
- [DevShell Configuration](modules/home-manager/devshell/README.md)
- [Zsh Configuration](modules/home-manager/terminal/zsh/README.md)
- [Neovim Setup](modules/home-manager/neovim/README.md)
