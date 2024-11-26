# Zsh Configuration

A modern, feature-rich Zsh configuration managed through Home Manager, providing an enhanced shell environment with integrated tools and productivity features.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Configuration](#configuration)
- [Usage](#usage)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

## Overview

This configuration provides a comprehensive Zsh environment optimized for development workflows. It integrates Oh My Zsh, custom plugins, and shell functions to create a powerful and user-friendly shell experience.

## Features

### Core Configuration
- Home Manager integration for declarative configuration
- Extended globbing and case-insensitive completion
- Custom environment variables for development tools
- Optimized history management

### Plugin Integration

#### Oh My Zsh
- Git integration for enhanced repository management
- Directory navigation with `z` jump
- macOS-specific optimizations
- Clipboard operations (`copypath`, `copyfile`)
- Archive extraction utilities
- Sudo command line editing
- Directory-specific environment management

#### Additional Plugins
- Auto-suggestions with smart history completion
- Syntax highlighting for commands and arguments
- Integration with direnv for environment management
- Fuzzy finding capabilities with fzf

### Command Aliases

#### System Management
```bash
# Nix Operations
swnix        # Rebuild and switch configuration (verbose)
drynix       # Dry-build configuration
updatanix    # Update and rebuild configuration
cleanix      # Clean Nix store
nix-store-du # Print dead store entries

# Development Environment
nixdev       # Enter Nix development shell
```

#### Container Operations
```bash
# Podman Management
pps          # List containers (formatted)
pclean       # Clean stopped containers
piclean      # Remove dangling images
pcomp        # Podman compose shorthand
```

#### Kubernetes Operations
```bash
# Cluster Management
k            # kubectl shorthand
kgaa         # Get all resources
kgpsn        # Get pods in namespace
krestartpo   # Restart deployment
```

#### Version Control
```bash
# Git Operations
gaa          # Git add all
gcmsg        # Git commit with message
gitsave      # Quick save changes
gpush        # Push to current/specified branch
```

### Shell Functions

#### Configuration Management
- `dots()`: Navigate to Nix configuration
- `savedots [message]`: Save configuration changes
- `rebuild()`: Rebuild system configuration

#### Maintenance
- `sfu()`: Update Nix flake
- `garbage()`: Run store optimization
- `news()`: Check Home Manager updates

## Configuration

### Directory Structure
```
zsh/
├── aliases.nix       # Command shortcuts
├── default.nix       # Shell and plugin settings
├── lib               # oh-my-zsh Library functions
├── oh-my-zsh.sh      # oh-my-zsh installer
├── themes                  # Prompt themes
│   ├── agnoster.zsh-theme
│   └── powerlevel10k
└── tools             # oh-my-zsh Utility scripts
```

### Required Components
- Nix package manager
- Home Manager
- Git

### Core Packages
- `direnv`: Environment management
- `fzf`: Fuzzy finding
- Essential Unix utilities

## Usage

### Installation
Add to your Home Manager configuration:
```nix
{
  programs.zsh.enable = true;
  imports = [ ./zsh/default.nix ];
}
```

### Updates
```bash
swnix        # Full rebuild with verbose output
drynix       # Test configuration changes
updatanix    # Update and rebuild system
```

## Maintenance

### Configuration Files
- `default.nix`: Shell and plugin settings
- `aliases.nix`: Command shortcuts
- `scripts.nix`: Shell functions
- `themes/jetpack.toml`: Prompt configuration

### Update Process
1. Modify configuration files as needed
2. Test changes with `drynix`
3. Apply changes with `swnix`
4. Monitor `news()` for updates

## Troubleshooting

### Common Issues
1. **Plugin Loading Failures**
   - Verify plugin configuration in `default.nix`
   - Check package availability

2. **Performance Issues**
   - Review enabled plugins
   - Monitor startup time with `zprof`
   - Check for conflicting configurations

3. **Prompt Display Problems**
   - Verify oh-my-zsh installation
   - Check font compatibility
   - Review theme configuration
