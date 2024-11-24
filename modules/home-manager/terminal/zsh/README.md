## Directory Structure

```
zsh/
├── default.nix       # Main Nix configuration file
├── aliases.nix      # Custom shell aliases
├── scripts.nix      # Custom shell scripts
└── themes/          # Starship theme files
    └── jetpack.toml # Current Starship theme
```

# Zsh Configuration

This directory contains a customized Zsh shell configuration managed through Home Manager. The setup includes Oh My Zsh, custom plugins, aliases, and Starship prompt integration.

## Features

### Shell Configuration
- Uses Home Manager's built-in Zsh module
- Configured in `~/.config/zsh` directory
- Interactive shell features enabled
- Extended globbing support
- Case-insensitive completion

### Oh My Zsh Integration
Active plugins:
- `git`: Enhanced Git commands and aliases
- `sudo`: Press ESC twice to add sudo to current command
- `history`: Enhanced history command functionality
- `direnv`: Directory-specific environment variables
- `copypath`: Copy current directory path to clipboard
- `copyfile`: Copy file contents to clipboard
- `extract`: Smart archive extraction
- `z`: Quick directory jumping
- `macos`: macOS-specific commands and aliases

### Additional Plugins
1. **zsh-autosuggestions** (v0.7.0)
   - Fish-like autosuggestions for Zsh
   - Suggests commands based on history

2. **zsh-syntax-highlighting** (v0.7.1)
   - Syntax highlighting for Zsh commands
   - Highlights valid commands, paths, and options

### Aliases
Comprehensive set of aliases for:
- NixOS and Nix package management
  - `swnix`: Rebuild and switch configuration
  - `drynix`: Dry-build configuration
  - `bootnix`: Rebuild for next boot
  - `cleanix`: Clean Nix store
  - `updatanix`: Update and rebuild configuration
  
- Kubernetes operations
  - `k`: kubectl shorthand
  - `kg`: kubectl get
  - `kd`: kubectl describe
  - `kap`: kubectl apply -f
  
- Podman container management
  - `pps`: List containers with formatted output
  - `pclean`: Clean up stopped containers
  - `piclean`: Remove dangling images

## Starship Prompt

### Current Setup
- Integrated with Zsh using Starship
- Configuration loaded from external TOML file
- Custom prompt format with rich information display

### Adding Custom Themes
1. Create a new theme file in `/modules/home-manager/starship/themes/`:
   ```bash
gst          # git status
ga           # git add
gcm          # git checkout main
gp           # git push
```

### Directory Navigation
```bash
z downloads  # Jump to Downloads directory
copypath     # Copy current directory path
```

### File Operations
```bash
extract archive.tar.gz  # Extract any archive format
copyfile script.sh      # Copy file contents to clipboard
```

### Environment Management
```bash
# Create a .envrc file in your project directory
echo 'export API_KEY="secret"' > .envrc
# direnv will automatically load/unload when entering/leaving the directory
```

## Customization

### Starship Theme
The Starship prompt can be customized by modifying `themes/jetpack.toml`. Common customizations include:
- Changing segment colors
- Adding/removing prompt segments
- Modifying segment content

### Adding New Aliases
Add new aliases in `aliases.nix`:
   ```nix
   xdg.configFile."starship.toml" = {
     source = ./themes/your-theme-name.toml;
   };
   ```

### Available Theme Palettes
- Catppuccin Mocha
- Tokyo Night
- Custom color schemes can be added in the theme file

## Installation and Updates

### Prerequisites
- Nix package manager
- Home Manager
- Git (for plugin management)

### Required Packages
The following packages are automatically installed:
- `direnv`: For directory-specific environment management
- `fzf`: For fuzzy finding functionality

### Updating Configuration
1. Modify the relevant files:
   - `default.nix`: For Zsh and plugin configuration
   - `aliases.nix`: For custom aliases
   - `starship.toml`: For prompt configuration

2. Rebuild your configuration:
   ```bash
   darwin-rebuild switch
   ```

## Troubleshooting

### Common Issues
1. **Plugin Loading Failures**
   - Check if the plugin is properly defined in `default.nix`
   - Verify the plugin's SHA256 hash

2. **Starship Prompt Issues**
   - Ensure Starship is installed: `which starship`
   - Check your theme file syntax
   - Verify the theme path in `default.nix`

3. **Performance Issues**
   - Disable unused plugins
   - Check for conflicting configurations
   - Monitor startup time with `zprof`
