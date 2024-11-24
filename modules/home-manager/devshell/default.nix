{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.devshell;
in {
  options.programs.devshell = {
    enable = lib.mkEnableOption "devshell development environment";
    shellConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        # Source cargo environment
        if [ -f "${config.home.homeDirectory}/.cargo/env" ]; then
          source "${config.home.homeDirectory}/.cargo/env"
        fi

        # Ensure Rust toolchain is configured
        if command -v rustup >/dev/null 2>&1 && ! command -v rustc >/dev/null 2>&1; then
          echo "Setting up Rust toolchain..."
          rustup default stable
        fi

        # Source Python venv if it exists
        if [ -f "${config.home.homeDirectory}/.local/share/devshell/venv/bin/activate" ]; then
          source "${config.home.homeDirectory}/.local/share/devshell/venv/bin/activate"
        fi

        # Python virtual environment management
        function mkvenv() {
          if [ ! -d "venv" ]; then
            python -m venv venv
            source venv/bin/activate
            pip install --upgrade pip
            echo "Created and activated new virtual environment"
          else
            echo "Virtual environment already exists"
          fi
        }

        function rmvenv() {
          if [ -d "venv" ]; then
            deactivate 2>/dev/null
            rm -rf venv
            echo "Removed virtual environment"
          else
            echo "No virtual environment found"
          fi
        }

        # Development environment info with error handling
        function devinfo() {
          echo " Development Environment Information"
          echo "=====================================\n"

          echo " Project: $(basename $(pwd))"

          echo -n " Python: "; if command -v python >/dev/null 2>&1; then python --version 2>&1; else echo "not installed"; fi
          echo -n " Go: "; if command -v go >/dev/null 2>&1; then go version 2>&1; else echo "not installed"; fi
          echo -n " Rust: "; if command -v rustc >/dev/null 2>&1; then rustc --version 2>&1; else echo "not installed"; fi
          echo -n " Node: "; if command -v node >/dev/null 2>&1; then node --version 2>&1; else echo "not installed"; fi
          echo -n " Git: "; if command -v git >/dev/null 2>&1; then git --version 2>&1; else echo "not installed"; fi
          echo -n " Nix: "; if command -v nix >/dev/null 2>&1; then nix --version 2>&1; else echo "not installed"; fi

          echo "Environment Variables:"
          echo ""
          echo "GOPATH: ${config.home.sessionVariables.GOPATH}"
          echo "PYTHONPATH: ${config.home.sessionVariables.PYTHONPATH}"
          echo "NODE_PATH: ${config.home.sessionVariables.NODE_PATH}"
          echo "PATH: $PATH"
        }

        # Development aliases
        alias dev="devinfo"
        alias update-dev="nix flake update"
        alias clean-dev="nix-collect-garbage -d"

        # Git aliases
        alias gaa="git add ."
        alias gcmsg="git commit -m"
        alias gst="git status ."
        alias gitsave="gaa && gcmsg '.' && gpush"
        alias gco="git checkout"
        alias gcb="git checkout -b"
        alias gcm="git checkout main"
        alias gl="git log --oneline --graph"
        alias gpull="git pull --rebase"
        alias gpush="git push"
        alias glast="git log -1 HEAD"

        echo "🚀 Entering development environment"
        echo ""
        echo "📂 Project: $(basename $(pwd))"
        echo "🐍 Python environment: $VENV_DIR"
        echo "🐹 Go environment: $GOPATH"
        echo "📦 Node environment: $NODE_PATH"
        echo "⚙️  Rust environment: $CARGO_HOME"

        echo ""
        echo "🔧 Tool versions:"
        echo "🔷 Python: $(python --version 2>&1)"
        echo "🐹 Go: $(go version 2>&1)"
        echo "⬢ Node: $(node --version 2>&1)"
        echo "🦀 Rust: $(rustc --version 2>&1)"
        echo "🌳 Git: $(git --version 2>&1)"
        echo "🔒 Nix: $(nix --version 2>&1)"

        echo ""
        echo "Type 'dev' to see full environment information"
      '';
    };
    pre-commit = {
      enable = lib.mkEnableOption "pre-commit hooks";
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {
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
        description = "Pre-commit hook settings";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # Enable direnv
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # Configure zsh with better history
      programs.zsh = {
        enable = true;
        history = {
          size = 10000;
          save = 10000;
          ignoreDups = true;
          ignoreSpace = true;
          expireDuplicatesFirst = true;
        };
      };

      home.packages = with pkgs; let
        python = python311;
        nodejs = nodejs_20;
      in
        [
          # Development tools
          gh
          gnumake
          cmake
          ninja
          gcc
          go
          rustup
          nodejs
          python
          python.pkgs.pip
          python.pkgs.pipx

          # Build tools
          pkg-config
          autoconf
          automake
          libtool

          # Debugging and analysis
          gdb
          lldb

          # Additional CLI tools
          ripgrep # Fast text search
          fd # Better find
          jq # JSON processor
          yq # YAML processor
          htop # Process viewer
          tree # Directory structure viewer
          curl # HTTP client
          wget # File downloader
          tmux # Terminal multiplexer
        ]
        ++ lib.optionals (!pkgs.stdenv.isDarwin) [
          valgrind # Only include valgrind on non-Darwin systems
        ]
        ++ [
          # Version control
          git-crypt
          pre-commit
          shellcheck
        ];

      home.sessionVariables = {
        # Python configuration
        PYTHONPATH = "${config.home.homeDirectory}/.local/share/devshell/venv/lib/python3.11/site-packages:$PYTHONPATH";
        PIP_PREFIX = "${config.home.homeDirectory}/.local/share/devshell/venv";

        # Go configuration
        GOPATH = "${config.home.homeDirectory}/.go";
        GOBIN = "${config.home.homeDirectory}/.go/bin";

        # Node.js configuration
        NODE_PATH = "${config.home.homeDirectory}/.node_modules";
        NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";

        # Rust configuration
        RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
        CARGO_HOME = "${config.home.homeDirectory}/.cargo";

        # General development
        EDITOR = "nvim";
        VISUAL = "nvim";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };

      home.sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
        "${config.home.sessionVariables.GOBIN}"
        "${config.home.homeDirectory}/.cargo/bin"
        "${config.home.sessionVariables.NPM_CONFIG_PREFIX}/bin"
      ];

      home.activation = {
        createDevDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
          # Create development directories with error handling
          for dir in \
            "${config.home.homeDirectory}/.local/bin" \
            "${config.home.homeDirectory}/.local/share/devshell/venv" \
            "${config.home.homeDirectory}/.go" \
            "${config.home.homeDirectory}/.cargo" \
            "${config.home.homeDirectory}/.node_modules" \
            "${config.home.homeDirectory}/.npm-global"; do
            if ! mkdir -p "$dir" 2>/dev/null; then
              echo "Failed to create directory: $dir"
            fi
          done

          # Setup Python virtual environment if it doesn't exist
          if [ ! -d "${config.home.homeDirectory}/.local/share/devshell/venv" ]; then
            ${pkgs.python311}/bin/python3 -m venv "${config.home.homeDirectory}/.local/share/devshell/venv"
          fi

          # Initialize rustup and set default toolchain
          if ! command -v rustc >/dev/null 2>&1; then
            echo "Initializing Rust toolchain..."
            ${pkgs.rustup}/bin/rustup-init -y --no-modify-path
            source ${config.home.homeDirectory}/.cargo/env
            ${pkgs.rustup}/bin/rustup default stable
          fi
        '';
      };

      programs.zsh.initExtra = config.programs.devshell.shellConfig;
    }

    (lib.mkIf cfg.pre-commit.enable {
      home.packages = with pkgs; [
        nixpkgs-fmt
        alejandra
        deadnix
        statix
        ruff
      ];

      xdg.configFile."pre-commit/config.yaml".text = ''
        repos:
        - repo: local
          hooks:
            - id: alejandra
              name: alejandra
              entry: alejandra
              language: system
              types: [nix]

            - id: shellcheck
              name: shellcheck
              entry: shellcheck
              language: system
              types: [shell]
              args: ["-s", "zsh", "--external-sources"]

            - id: deadnix
              name: deadnix
              entry: deadnix
              language: system
              types: [nix]

            - id: statix
              name: statix
              entry: bash -c 'for file in "$@"; do statix check "$file"; done' --
              language: system
              types: [nix]

            - id: ruff
              name: ruff
              entry: ruff check --fix
              language: system
              types: [python]

            - id: ruff-format
              name: ruff-format
              entry: ruff format
              language: system
              types: [python]
      '';
    })
  ]);
}
