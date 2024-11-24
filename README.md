# Nix Darwin Configuration

This repository contains my personal nix-darwin configuration for managing macOS system configuration using Nix. It uses a combination of nix-darwin and home-manager to provide a simple and efficient system and user environment management solution.

## Features

- 🚀 Complete macOS system configuration using nix-darwin
- 🏠 User environment management with home-manager
- 🛠 Neovim configuration with LSP support and essential development tools
- 📦 Homebrew package management integration
- ⚡️ Fast and reproducible system setup
- 🧹 Automated maintenance (garbage collection and store optimization)

## System Maintenance

The system is configured with automated maintenance tasks:

### Garbage Collection
- Runs automatically every Sunday at 2 AM
- Deletes generations older than 30 days
- Configured in `flake.nix`:
```nix
nix.gc = {
  automatic = true;
  interval = { Weekday = 0; Hour = 2; Minute = 0; };
  options = "--delete-older-than 30d";
};

#### Neovim Configuration
- **Neovim** with LSP support including:
  - Lua, TypeScript, HTML/CSS/JSON, Bash
  - Python, GraphQL, Rust, Terraform, Nix
  - Markdown and LaTeX support
- Modern UI with Tokyo Night theme integration
- Efficient code navigation and editing features

#### Terminal Setup
- **Alacritty**: Modern GPU-accelerated terminal
  - Custom font configuration (JetBrainsMono Nerd Font)
  - Tokyo Night theme integration
  - macOS-specific optimizations
  - **Zsh**: Customized shell environment with Oh-My-Zsh ([configuration details](modules/home-manager/terminal/zsh/README.md))
  - Integrated with Nix Home Manager

#### Development Tools
- Git configuration with meld integration
- SSH configuration with macOS keychain integration
- Lazygit with custom theme and keybindings
- **DevShell**: Customized development environment ([configuration details](modules/home-manager/devshell/README.md))
  - Python, Rust, Go, and Node.js support
  - Build tools and debugging utilities
  - Automated environment setup
  - Pre-commit hooks for code formatting and analysis

#### Kubernetes Management
- Kubernetes tooling:
  - kubectl, helm, k9s, cilium-cli
  - kustomize, talosctl, krew

### System Configuration

#### Security
- Touch ID authentication for sudo
- Secure SSH configuration with keychain integration
- Trusted Nix substituters and public keys

#### UI/UX
- Custom dock configuration
  - Auto-hide enabled
  - Persistent apps configuration
- Finder enhancements
  - POSIX path in title
  - Column view by default
- Screenshot location configuration

#### Font Management
- Nerd Fonts integration:
  - JetBrainsMono
  - FiraCode
  - IBMPlexMono
- Noto fonts for Unicode support
```

## Directory Structure
```bash
.nix-darwin-config/
├── flake.lock               # Nix lock file
├── flake.nix                # Nix flake definition
├── home-manager
│   └── home.nix             # Home-manager entry point
├── modules
│   ├── home-manager         # User-specific configurations
│   │   ├── btop
│   │   │   └── themes
│   │   ├── cli
│   │   │   └── zoxide
│   │   ├── devshell
│   │   ├── emacs
│   │   ├── neovim
│   │   │   └── lua
│   │   │       ├── config
│   │   │       └── plugins
│   │   ├── starship
│   │   ├── terminal
│   │   │   ├── alacritty
│   │   │   ├── wezterm
│   │   │   ├── zellij
│   │   │   └── zsh
│   │   └── tmux
│   │       └── scripts
│   └── nix-darwin           # System-level configurations
│       └── nixd
├── nixos
│   └── hosts                # Host-specific configurations
│       └── wm-macbook-pro
├── overlays                 # Nix overlays
└── pkgs                     # Nix packages
```

## Installation

1. Install Nix using Determinate Systems' installer:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Enable Flakes:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. Clone this repository:
```bash
git clone https://github.com/Hackiri/nix-darwin-config.git ~/.nix-darwin-config
```

4. Edit the configuration to match your username and hostname:
   - Open `flake.nix` and replace `wm-macbook-pro` with your desired hostname
   - Open `nixos/hosts/wm-macbook-pro/configuration.nix` and update:
     ```nix
     # Replace with your username
     users.users.wm = {
       name = "your-username";
       home = "/Users/your-username";
     };
     ```
   - Rename the host directory to match your hostname:
     ```bash
     mv nixos/hosts/wm-macbook-pro nixos/hosts/your-hostname
     ```
   - Update references in `flake.nix` and other files to match your new hostname

5. Build and switch to the configuration:
```bash
cd ~/.nix-darwin-config
nix build .#darwinConfigurations.your-hostname.system
darwin-rebuild switch --flake .
```

## Maintenance

### Updates
To update the system and all packages:
```bash
darwin-rebuild switch --flake .
```

### Garbage Collection
Automatic garbage collection is configured to run weekly, removing generations older than 30 days.

### Application Management
All applications are managed through a centralized system in `/Applications/Nix Apps/`, providing a clean and organized application structure.

## Customization

The configuration is modular and can be easily customized:
- System-level settings in `nixos/hosts/wm-macbook-pro/configuration.nix`
- User-level settings in `home-manager/home.nix`
- Individual components in their respective module directories.

## Contributing

Feel free to use this configuration as inspiration for your own setup. Issues and pull requests are welcome for improvements or bug fixes.
