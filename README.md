# Nix Darwin Configuration

A comprehensive system configuration for macOS using nix-darwin and Home Manager, providing a declarative and reproducible development environment.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Maintenance](#maintenance)

## Overview

This repository contains a complete nix-darwin configuration that manages both system-level settings and user environments on macOS. It combines nix-darwin for system configuration with Home Manager for user environment management, creating a fully reproducible and declarative setup.

## Features

### Core Components
- 🚀 Declarative macOS system configuration
- 🏠 User environment management
- 📦 Homebrew integration
- ⚡️ Fast and reproducible builds
- 🧹 Automated maintenance

### Development Environment
- **Neovim Configuration**
  - LSP support for multiple languages
  - Modern UI with Tokyo Night theme
  - Efficient code navigation
  - Integrated debugging

- **Terminal Environment**
  - Alacritty with GPU acceleration
  - Custom font configuration
  - Zsh with extensive customization
  - Tmux integration

- **Programming Support**
  - Multiple language environments
  - Build tools and debuggers
  - Container management
  - Kubernetes tooling

### System Features
- Touch ID authentication
- Secure SSH configuration
- Custom font management
- Automated maintenance

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
git clone https://github.com/Hackiri/nix-darwin-config.git ~/.nix-darwin-config
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
- **Terminal**: GPU-accelerated Alacritty
- **Tools**: Development utilities

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
