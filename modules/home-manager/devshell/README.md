# Development Shell Configuration

This directory contains the configuration for a comprehensive development environment using Nix and Home Manager.

## Overview

The development shell provides a consistent and reproducible development environment with pre-configured tools and settings for various programming languages and development tasks.

## Features

### Programming Languages & Tools

- **Python**
  - Python 3.11 with pip and pipx
  - Automatic virtual environment setup at `~/.local/share/devshell/venv`
  - Virtual environment auto-activation in shell
  - Project-specific venv management with `mkvenv` and `rmvenv` commands

- **Rust**
  - Rustup with stable toolchain
  - Automatic toolchain initialization
  - Cargo environment integration at `~/.cargo`

- **Go**
  - Go development environment
  - Configured GOPATH at `~/.go`
  - Binary path integration

- **Node.js**
  - Node.js 20.x
  - NPM package management
  - Global packages at `~/.npm-global`
  - Node modules at `~/.node_modules`

### Development Tools

- **Version Control**
  - Git with LFS support
  - Git Delta for better diffs
  - Git-crypt for encryption
  - Pre-commit hooks support
  - Convenient git aliases (g, gst, gc, gp, gl)

- **Pre-commit Hooks**
  - Nix code formatting with `nixpkgs-fmt` and `alejandra`
  - Shell script analysis with `shellcheck`
  - Dead code detection with `deadnix`
  - Static analysis with `statix`
  - Customizable through home.nix:
    ```nix
    programs.devshell.pre-commit.settings = {
      hooks = {
        nixpkgs-fmt.enable = true;
        shellcheck.enable = true;
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
      };
      settings = {
        deadnix.noLambdaArg = true;
        statix.format = "stderr";
      };
    };
    ```

- **Build Tools**
  - GNU Make
  - CMake
  - Ninja
  - GCC
  - pkg-config
  - autoconf
  - automake
  - libtool

- **CLI Tools**
  - ripgrep (fast text search)
  - fd (better find)
  - jq (JSON processor)
  - yq (YAML processor)
  - htop (process viewer)
  - tree (directory structure viewer)
  - curl & wget
  - tmux (terminal multiplexer)

- **Debugging**
  - GDB
  - LLDB
  - Valgrind (non-Darwin systems only)

### Shell Features

- **Environment Information**
  - Welcoming development environment info on shell entry
  - `dev` command shows detailed environment status
  - Displays versions of installed tools
  - Shows environment variables and paths

- **Development Tools**
  - direnv integration for project-specific environments
  - Improved shell history management
  - UTF-8 locale configuration

- **Utility Commands**
  - `dev`: Show environment information
  - `update-dev`: Update Nix flake
  - `clean-dev`: Run garbage collection
  - `mkvenv`: Create a new Python virtual environment
  - `rmvenv`: Remove a Python virtual environment
  - `hms`: Shortcut for home-manager switch

### Directory Structure

```
~/.local/
├── bin/                    # Local binaries
└── share/
    └── devshell/
        └── venv/          # Python virtual environment

~/.go/                     # Go workspace
└── bin/                   # Go binaries

~/.cargo/                  # Rust/Cargo configuration
└── bin/                   # Rust binaries

~/.npm-global/             # Global NPM packages
└── bin/                   # NPM binaries

~/.node_modules/           # Node.js modules

~/.rustup/              # Rust toolchains
~/.cargo/               # Cargo packages
```

## Usage

### Entering the Development Shell

From your Nix flake directory:
```bash
nix develop
```

You'll be greeted with a welcome message showing:
- Current project name
- Environment paths (Python, Go, Node, Rust)
- Installed tool versions

### Environment Information
- Run `dev` to see detailed environment information
- The welcome message shows key environment paths and tool versions

### Python Virtual Environments
- `mkvenv`: Create a new virtual environment in the current directory
- `rmvenv`: Remove the virtual environment in the current directory

### Pre-commit Hooks
1. Enable pre-commit hooks in any git repository:
   ```bash
   pre-commit install
   ```

2. The hooks will automatically run on every commit, checking for:
   - Nix code formatting issues
   - Shell script problems
   - Dead Nix code
   - Static analysis warnings

3. Run hooks manually:
   ```bash
   pre-commit run --all-files  # Check all files
   pre-commit run             # Check staged files only
   ```

### Development Commands
- `update-dev`: Update Nix flake
- `clean-dev`: Run garbage collection
- `hms`: Shortcut for home-manager switch

### Git Aliases
- `gaa`: Git add all
- `gcmsg`: Git commit with message
- `gst`: Git status
- `gco`: Git checkout
- `gcb`: Git checkout new branch
- `gcm`: Git checkout main
- `gl`: Git log with graph
- `gpull`: Git pull with rebase
- `gpush`: Git push
- `glast`: Show last commit

## Configuration

### Main Components

1. **default.nix**
   - Main configuration file
   - Defines development shell options and behavior
   - Configures programming language environments
   - Sets up shell utilities and commands

2. **Integration with flake.nix**
   - Imported as a home-manager module
   - Provides development shell configuration
   - Manages package dependencies

## Environment Variables

The following environment variables are automatically configured:

- `PYTHONPATH`: Python package path
- `PIP_PREFIX`: pip installation prefix
- `GOPATH`: Go workspace
- `GOBIN`: Go binaries
- `NODE_PATH`: Node.js modules
- `NPM_CONFIG_PREFIX`: NPM global packages
- `RUSTUP_HOME`: Rust toolchain
- `CARGO_HOME`: Cargo configuration
- `EDITOR`/`VISUAL`: Set to "nvim"
- `LANG`/`LC_ALL`: Set to "en_US.UTF-8"

## Customization

To modify the development environment:

1. **Add New Packages**
   - Edit the `home.packages` list in `default.nix`

2. **Modify Shell Behavior**
   - Update the `shellConfig` option in `default.nix`

3. **Add Environment Variables**
   - Add to `home.sessionVariables` in `default.nix`

4. **Add Path Entries**
   - Add to `home.sessionPath` in `default.nix`

## Troubleshooting

### Rust Toolchain Issues
If Rust isn't properly initialized:
```bash
rustup default stable
```