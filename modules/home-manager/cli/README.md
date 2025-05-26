# CLI Tools Configuration

This directory contains configurations for command-line interface (CLI) tools used in the nix-darwin setup.

## Directory Structure

Each tool has its own directory with a `default.nix` file that configures the tool. Some tools may have additional configuration files.

## Included Tools

- **bat**: A `cat` clone with syntax highlighting and Git integration
- **direnv**: Environment switcher for the shell
- **eza**: Modern replacement for `ls`
- **fd**: Simple, fast, and user-friendly alternative to `find`
- **gh**: GitHub CLI
- **gpg**: GNU Privacy Guard for encryption and signing
- **jq**: Lightweight and flexible command-line JSON processor
- **ripgrep**: Fast search tool similar to `grep`
- **ssh**: Secure Shell configuration
- **zellij**: Terminal workspace with multiplexer capabilities
- **zoxide**: Smarter `cd` command that learns your habits

## Adding New Tools

To add a new CLI tool:

1. Create a new directory for the tool: `mkdir toolname`
2. Create a default.nix file: `touch toolname/default.nix`
3. Configure the tool in the default.nix file
4. Import the tool in the `default.nix` file in this directory

## Example Configuration

A typical tool configuration looks like:

```nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.toolname = {
    enable = true;
    # Additional configuration options
  };
}
```

## Best Practices

- Keep configurations modular and focused on a single tool
- Use comments to explain non-obvious configuration choices
- Consider creating separate configuration files for complex setups
- Prefer home-manager's built-in modules when available
