# Nix-Darwin Configuration Architecture

This document explains the architecture and design decisions of this nix-darwin configuration.

## Directory Structure

- **flake.nix**: The entry point for the configuration. Defines inputs, outputs, and the overall structure.
- **home-manager/**: Contains the home-manager configuration for user-specific settings.
- **modules/**: Contains modular configurations for different aspects of the system.
- **nixos/hosts/**: Contains host-specific configurations.
- **overlays/**: Contains custom overlays for modifying packages.
- **pkgs/**: Contains custom package definitions.

## Design Principles

1. **Modularity**: Each component is separated into its own module for better organization and reusability.
2. **Declarative Configuration**: All system and user settings are defined declaratively.
3. **Reproducibility**: The configuration aims to be fully reproducible across different machines.
4. **Separation of Concerns**: Clear distinction between system-level (nix-darwin) and user-level (home-manager) configurations.

## Package Management Strategy

This configuration uses a hybrid approach to package management:

- **Nix Packages**: Used for most command-line tools and development dependencies.
- **Homebrew**: Used for macOS-specific applications and GUI applications that don't work well with Nix.

## Separation of Concerns

### System-Level Configuration (nix-darwin)

The nix-darwin configuration focuses on system-wide settings:

- **System Services**: Configuration for system-level services and daemons
- **macOS Defaults**: System-wide macOS preference settings
- **Security Settings**: System security configurations
- **Core System Utilities**: Essential utilities required for system operation (e.g., mkalias, pam-reattach)
- **Homebrew Management**: Installation and management of Homebrew packages and casks

### User-Level Configuration (home-manager)

The home-manager configuration focuses on user-specific settings:

- **User Packages**: All user-level packages and tools
- **Shell Configuration**: Complete shell setup including aliases, functions, and plugins
- **Development Tools**: Programming languages, development environments, and tools
- **Application Configuration**: User-specific application settings

## Module Organization

- **CLI Tools**: Located in `modules/home-manager/cli/`, these modules configure command-line tools.
- **Terminal**: Located in `modules/home-manager/terminal/`, these modules configure terminal emulators and shells.
- **Editors**: Located in `modules/home-manager/neovim/` and `modules/home-manager/emacs/`, these modules configure text editors.

## Customization

To customize this configuration:

1. Edit host-specific settings in `nixos/hosts/<hostname>/configuration.nix`.
2. Edit user-specific settings in `home-manager/home.nix`.
3. Add or modify modules in the `modules/` directory.

## Maintenance

Regular maintenance tasks:

1. Update flake inputs: `nix flake update`
2. Rebuild the system: `darwin-rebuild switch --flake .`
3. Clean old generations: `nix-collect-garbage -d`

## Troubleshooting

Common issues and solutions:

- **Homebrew Cask Untapping Error**: This is a known issue with Homebrew integration. The configuration uses `mutableTaps = true` to work around it.
- **Type String Deprecation**: The configuration includes a fix-types overlay to handle deprecated `types.string` usage.
