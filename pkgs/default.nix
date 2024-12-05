# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#customPkgs.package-name'
{pkgs ? import <nixpkgs> {}}: rec {
  # Development helper scripts
  dev-tools =
    pkgs.callPackage
    (
      {pkgs}: let
        name = "dev-tools";
        script = ''
          #!${pkgs.bash}/bin/bash

          # Set strict bash options
          set -euo pipefail

          # Help message
          show_help() {
            echo "Development Tools Helper"
            echo "Usage: dev-tools <command> [args]"
            echo ""
            echo "Commands:"
            echo "  clean    - Clean development artifacts (*.pyc, __pycache__, etc.)"
            echo "  format   - Format code in the current directory"
            echo "  lint     - Run linters on the code"
            echo "  help     - Show this help message"
          }

          # Clean development artifacts
          clean_artifacts() {
            echo "🧹 Cleaning development artifacts..."
            find . -type d -name "__pycache__" -exec rm -rf {} +
            find . -type f -name "*.pyc" -delete
            find . -type f -name ".DS_Store" -delete
            find . -type d -name ".pytest_cache" -exec rm -rf {} +
            find . -type d -name ".mypy_cache" -exec rm -rf {} +
            echo "✨ Clean complete!"
          }

          # Format code
          format_code() {
            echo "🎨 Formatting code..."
            if [ -f "*.py" ]; then
              ${pkgs.black}/bin/black .
            fi
            if [ -f "*.lua" ]; then
              ${pkgs.stylua}/bin/stylua .
            fi
            if [ -f "*.nix" ]; then
              ${pkgs.alejandra}/bin/alejandra -q .
            fi
            echo "✨ Formatting complete!"
          }

          # Lint code
          lint_code() {
            echo "🔍 Linting code..."
            if [ -f "*.py" ]; then
              ${pkgs.ruff}/bin/ruff check .
            fi
            if [ -f "*.nix" ]; then
              ${pkgs.statix}/bin/statix check .
            fi
            echo "✨ Linting complete!"
          }

          # Main command handler
          case "''${1:-help}" in
            "clean")
              clean_artifacts
              ;;
            "format")
              format_code
              ;;
            "lint")
              lint_code
              ;;
            "help"|*)
              show_help
              ;;
          esac
        '';
      in
        pkgs.writeShellApplication {
          inherit name;
          text = script;
          runtimeInputs = with pkgs; [
            # Basic utilities
            coreutils
            findutils

            # Development tools
            black
            ruff
            stylua
            alejandra
            statix
          ];
        }
    )
    {};
}
