# Nix Darwin Configuration

Nix system configuration for macOS using nix-darwin and Home Manager, providing a declarative and reproducible user environment.


## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation and Setup Guide](#installation-and-setup-guide)
- [Maintenance](#maintenance)

## Overview

This repository contains a complete nix-darwin configuration that manages both system-level settings and user environments on macOS. It combines nix-darwin for system configuration with Home Manager for user environment management, creating a fully reproducible and declarative setup.

## Features

### Core Components
- **Declarative macOS Configuration**
  - System-wide settings management
  - Host & user-specific configuration 
  - Homebrew integration via `nix-homebrew`
  - Package management via `nixpkgs` and `nix-darwin`
  
- **User Environment Management**
  - User-specific home directory configuration
  - XDG base directory support
  - Dotfiles management
  - Application settings synchronization

- **Package Management**
  - Nix Flakes for reproducible builds
  - Garbage collection & storage optimization
  - content-addressed derivations
  - Parallel build configuration
  - Binary cache configuration
  - Trusted user management

### Development Environment
- **Neovim Configuration**
  - LSP support for multiple languages
  - Code completion enhancements (supermaven, nvim-cmp)
  - Efficient code navigation (peeker)
  - Syntax highlighting and colorization
  - Custom color schemes
  - Quickfix list integration
  - Terminal integration
  - File browser integration
  - Git integration
  - Markdown previews

- **Git Configuration**
  - Git integration with Home Manager
  - Git-crypt for secure secrets
  - Git flow support (feature, bugfix, release, hotfix)   
  - Git commit hooks for code formatting and linting support (alejandra, deadnix, statix)

- **Terminal Environment**
  - Custom font configuration
  - Zsh with extensive customization
  - Tmux integration with zellij
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
- `overlays/`: Package modifications
- `pkgs/`: Custom packages


Note: Make sure to review the configuration files and adjust them according to your needs before building. The system configuration is primarily managed through the modules in the repository.

### Customizing Your Setup

After the initial installation, you can customize various aspects of your system:

1. **Shell Environment**
   - Edit aliases: `modules/home-manager/terminal/zsh/aliases.nix`
   - Configure terminal: `modules/home-manager/terminal/wezterm/main_config.lua` or `modules/home-manager/terminal/alacritty/alacritty.toml`
   - Customize prompt: `modules/home-manager/starship/starship.toml`

2. **Development Tools**
   - Configure editors: `modules/home-manager/neovim/default.nix` or `modules/home-manager/emacs/default.nix`
   - Set up dev environments: `modules/home-manager/devshell/default.nix`

3. **Package Management**
   - Add programs to import from home.nix: `modules/home-manager/default.nix`
   - Add programs to import from configuration.nix: `modules/nix-darwin/default.nix`
   - Add custom packages: `pkgs/default.nix`
   - Add custom overlays: `overlays/default.nix`

4. **System Preferences**
   - Modify system settings (dock, menu, fingerprint sudo, etc.): `configuration.nix`

5. **Secret Management** (Optional)
   - Initialize git-crypt for sensitive data
   - Store secrets in `secrets/secrets.nix`
   - Never commit unencrypted secrets

6. **Git Configuration** 
   - Configure git in `modules/home-manager/terminal/zsh/default.nix`
   - Use pre-commit hooks for code linting and formatting

## Installation and Setup Guide

### Prerequisites
- macOS 10.15 or later
- Administrative access
- Internet connection
- Basic knowledge of Nix/Nix Flakes

### Installation Steps

1. Install Nix
```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

2. Install Nix Flakes
```bash
# Enable flakes and nix-command in your Nix configuration
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. Initialize nix-darwin Configuration
```bash
# Create a basic nix-darwin configuration
mkdir -p ~/.nix-darwin-config
cd ~/.nix-darwin-config
nix flake init -t nix-darwin
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix

# Rebuild System Configuration
darwin-rebuild switch --flake . # Rebuild the system configuration will take some time
```

4. Clone Repository
```bash
# Backup your initial configuration (optional)
mv ~/.nix-darwin-config ~/.nix-darwin-config.bak

# Clone the repository
git clone https://github.com/Hackiri/nix-darwin-config.git ~/.nix-darwin-config
```

5. Customize Configuration
- Review and modify the configuration files according to your needs
- The main configuration is in `flake.nix` and the modules directory
- Update hostname and user-specific settings

4. Configure Your System

a. Copy Host Configuration
```bash
cp -r ~/.nix-darwin-config/nixos/hosts/wm-macbook-pro ~/.nix-darwin-config/nixos/hosts/YOUR-HOSTNAME
```

b. Update System Configuration
Edit `~/.nix-darwin-config/flake.nix`:
```nix
# Set correct system architecture
system = "aarch64-darwin"; # or "x86_64-darwin" for Intel Macs

# Update hostname and user configuration
darwinConfigurations = {
  "YOUR-HOSTNAME" = nix-darwin.lib.darwinSystem {
    # ...
  };
};

# Update username
users.your-username = import ./home-manager/home.nix;
```

c. Configure Host Settings
Edit `~/.nix-darwin-config/nixos/hosts/YOUR-HOSTNAME/configuration.nix`:
```nix
# Update system users and permissions
nix = {
  settings = {
    trusted-users = ["root" "@admin" "YOUR-USERNAME"];
  };
  gc = {
    user = "YOUR-USERNAME";
    options = "--delete-older-than 30d";
  };
};

# Update Homebrew user
nix-homebrew.user = "YOUR-USERNAME";

# Configure system user
users.users.YOUR-USERNAME = {
  name = "YOUR-USERNAME";
  home = "/Users/YOUR-USERNAME";
  shell = pkgs.zsh;
};
```

d. Set Up User Environment
Edit `~/.nix-darwin-config/home-manager/home.nix`:
```nix
home = {
  username = "YOUR-USERNAME";
  homeDirectory = "/Users/YOUR-USERNAME";
  stateVersion = "24.05";
};
```

e. Configure Git (Optional)
Edit `~/.nix-darwin-config/modules/home-manager/terminal/zsh/default.nix`:
```nix
    git = {
      enable = true;
      userName = "YOUR-USERNAME";  # Your GitHub username
      userEmail = "YOUR-GITHUB-NOREPLY-EMAIL";  # Your GitHub no-reply email
      
      # GPG signing configuration (optional)
      signing = {
        signByDefault = true;
        key = "YOUR-GPG-KEY-ID";  # Your GPG key ID from step 2 below
      };
      extraConfig = {
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };
```

6. Build and Apply Configuration
```bash
cd ~/.nix-darwin-config
darwin-rebuild switch --flake .
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
