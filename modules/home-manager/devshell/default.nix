{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.devshell = with lib; {
    enable = mkEnableOption "devshell configuration";
  };

  config = lib.mkIf config.programs.devshell.enable {
    home.packages = with pkgs;
      [
        # Shell and terminal utilities
        zsh
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-history-substring-search
        fzf
        bat
        eza # Modern replacement for ls
        fd
        ripgrep
        jq
        yq-go # YAML processor
        tree
        htop
        git
        git-lfs
        direnv
        nix-direnv

        # Development tools
        gh
        gnumake
        cmake
        ninja
        gcc
        go
        rustup
        nodejs
        python3
        python3Packages.pip
        python3Packages.pipx

        # Build tools
        pkg-config
        autoconf
        automake
        libtool

        # Debugging and analysis
        gdb
        lldb

        # Additional CLI tools
        curl
        wget
        tmux
      ]
      ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        valgrind # Only include valgrind on non-Darwin systems
      ]
      ++ [
        # Version control and code quality
        git-crypt
        pre-commit
        shellcheck
        nixpkgs-fmt
        alejandra
        deadnix
        statix
      ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      history.path = "${config.home.homeDirectory}/.zsh_history";

      initExtra = ''
        # Function to show welcome message
        show_welcome() {
          echo "🚀 Entering development environment"
          echo ""
          echo "📂 Project: $(basename $(pwd))"
          echo "🐍 Python environment: $VENV_DIR"
          echo "🐹 Go environment: $GOPATH"
          echo "📦 Node environment: $NODE_PATH"
          echo "⚙️  Rust environment: $CARGO_HOME"

          echo ""
          echo "🔧 Tool versions:"
          echo "🔷 Python: $(python3 --version 2>&1)"
          echo "🐹 Go: $(go version 2>&1)"
          echo "⬢ Node: $(node --version 2>&1)"
          echo "🦀 Rust: $(rustc --version 2>&1)"
          echo "🌳 Git: $(git --version 2>&1)"
          echo "🔒 Nix: $(nix --version 2>&1)"

        }

        # Function to initialize development environment
        devshellInit() {
          # Source environment files
          [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
          [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

          # Set environment variables
          export PYTHONPATH="$HOME/.local/lib/python3.9/site-packages:$PYTHONPATH"
          export GOPATH="$HOME/go"
          export PATH="$GOPATH/bin:$PATH"
          export NODE_PATH="$HOME/.npm-packages/lib/node_modules"
          export CARGO_HOME="$HOME/.cargo"
          export RUSTUP_HOME="$HOME/.rustup"

          # Show welcome message
          show_welcome
        }

        # Alias to manually enter development environment
        alias devshell='devshellInit'

        # Auto-run devshellInit when shell starts in nix develop
        if [ -n "$IN_NIX_SHELL" ]; then
          devshellInit
        fi
      '';

      shellAliases = {
        ls = "eza --icons -l -T -L=1";
        l = "ls -l";
        ll = "ls -alh";
        lsa = "ls -a";
        cat = "bat";
        find = "fd";
        grep = "rg";
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
