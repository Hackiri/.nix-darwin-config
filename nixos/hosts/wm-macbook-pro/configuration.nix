{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  # Import other NixOS modules here
  imports = [];

  # System-wide environment variables and packages
  environment = {
    variables = {
      # Ensure proper color support for terminals
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
    };

    # Essential system packages
    systemPackages = with pkgs; [
      # System utilities
      mkalias
      pam-reattach

      # Note: git, zsh, nix-direnv, and direnv moved to home-manager
    ];

    shells = [pkgs.zsh];

    # Shell aliases moved to home-manager zsh configuration
    shellAliases = {};
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      trusted-users = ["root" "@admin" "wm"];
      warn-dirty = false;
      # auto-optimise-store has been removed as it can corrupt the Nix store
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # Garbage collection settings
    gc = {
      automatic = true;
      options = "--delete-older-than 30d"; # Keep generations for 30 days
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      }; # Run GC weekly on Sundays at 3am
    };
    # Use optimise instead of auto-optimise-store
    optimise = {
      automatic = true;
    };
  };

  # Enable touch ID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Security settings - Touch ID for sudo is already configured with security.pam.services.sudo_local.touchIdAuth

  # System configuration
  system = {
    # Set the state version for nix-darwin
    stateVersion = 6;
    # Configure defaults
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        _FXShowPosixPathInTitle = true; # Show full path in Finder title
        FXPreferredViewStyle = "Nlsv"; # List view by default
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      # Login window settings
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      # Screenshot settings
      screencapture.location = "~/Pictures/Screenshots";

      # Screensaver settings
      screensaver.askForPasswordDelay = 10;

      # Dock settings
      dock = {
        autohide = true;
        show-recents = false;
        static-only = true; # Only show running applications
        mru-spaces = false; # Don't automatically rearrange spaces
      };
    };

    # Additional dock settings are already defined under system.defaults.dock

    # Login window settings are already defined under system.defaults.loginwindow

    # Configure activation scripts
    activationScripts = {
      postActivation.text = ''
        # Add pam_reattach to enable TouchID for tmux
        sudo mkdir -p /usr/local/lib/pam
        sudo cp ${pkgs.pam-reattach}/lib/pam/pam_reattach.so /usr/local/lib/pam/

        # Add pam_reattach to sudo config if not already present
        if ! grep -q "pam_reattach.so" /etc/pam.d/sudo; then
          sudo sed -i "" '2i\
        auth    optional    pam_reattach.so
        ' /etc/pam.d/sudo
        fi
      '';

      applications.text = ''
        # Improved atomic setup for /Applications/Nix Apps
        set -euo pipefail

        APPS_DIR="/Applications/Nix Apps"
        TMPDIR="$(mktemp -d)"
        BUILD_ENV="${pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        }}/Applications"

        echo "Setting up $APPS_DIR..." >&2

        # Copy system package apps
        find "$BUILD_ENV" -maxdepth 1 -type l | while read -r link; do
          src="$(readlink "$link")"
          app_name="$(basename "$src")"
          echo "copying $src" >&2
          if ! ${pkgs.mkalias}/bin/mkalias "$src" "$TMPDIR/$app_name"; then
            echo "Failed to create alias for $src" >&2
          fi

          # If Home Manager app exists, create alias with HM_ prefix
          HM_APP="$HOME/Applications/Home Manager Apps/$app_name"
          if [ -e "$HM_APP" ]; then
            echo "linking Home Manager app: $app_name" >&2
            if ! ${pkgs.mkalias}/bin/mkalias "$HM_APP" "$TMPDIR/HM_$app_name"; then
              echo "Failed to create alias for Home Manager app $HM_APP" >&2
            fi
          fi
        done

        # Atomic move
        rm -rf "$APPS_DIR"
        mv "$TMPDIR" "$APPS_DIR"

        # Disable Spotlight indexing only for Nix Apps
        echo "Disabling Spotlight indexing for $APPS_DIR..." >&2
        mdutil -i off -d "$APPS_DIR" &>/dev/null || true
      '';
    };
  };

  # Enable nix-index service to update nix packages
  programs.nix-index.enable = true;

  # Homebrew configuration
  homebrew = {
    enable = true;
    brews = [
      "webp"
      "mas"
      "ffmpeg"
      "podman-compose"
      "podman"
    ];
    casks = [
      "podman-desktop"
      "obsidian"
      "cmake"
      "pika"
      "slack"
      "discord"
      "firefox"
      "iina"
      "the-unarchiver"
      "wezterm"
      "wireshark"
      "raycast"
      "visual-studio-code"
      "ghostty"
    ];
    masApps = {};
    onActivation = {
      cleanup = "uninstall"; # Less aggressive than "zap", won't remove dependencies
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Homebrew user configuration
  nix-homebrew.user = "wm";

  # Add Podman Docker compatibility setup
  system.activationScripts.podmanDockerCompat = {
    text = ''
            # Set up Podman for Docker compatibility
            echo "Setting up Podman for Docker compatibility..." >&2

            # Create Docker compatibility symlinks
            mkdir -p $HOME/.local/bin
            ln -sf $(which podman) $HOME/.local/bin/docker
            ln -sf $(which podman-compose) $HOME/.local/bin/docker-compose

            # Ensure the bin directory is in PATH
            if ! grep -q "$HOME/.local/bin" $HOME/.zshrc; then
              echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.zshrc
            fi

            # Set up Docker socket compatibility
            mkdir -p $HOME/.docker

            # Create systemd user directory if it doesn't exist
            mkdir -p $HOME/.config/systemd/user

            # Create the service file for podman socket
            cat > $HOME/.config/systemd/user/podman.socket << EOF
      [Unit]
      Description=Podman API Socket
      Documentation=man:podman-system-service(1)

      [Socket]
      ListenStream=%t/podman/podman.sock
      SocketMode=0660

      [Install]
      WantedBy=sockets.target
      EOF

            # Create the service file
            cat > $HOME/.config/systemd/user/podman.service << EOF
      [Unit]
      Description=Podman API Service
      Requires=podman.socket
      After=podman.socket
      Documentation=man:podman-system-service(1)

      [Service]
      Type=simple
      ExecStart=/usr/local/bin/podman system service --time=0

      [Install]
      WantedBy=default.target
      EOF

            # Add Docker environment variables to zshrc if not already present
            if ! grep -q "DOCKER_HOST" $HOME/.zshrc; then
              echo 'export DOCKER_HOST="unix://$HOME/.local/share/containers/podman/machine/qemu/podman.sock"' >> $HOME/.zshrc
            fi
    '';
  };

  # Declare the user that will be running `nix-darwin`.
  users.users.wm = {
    name = "wm";
    home = "/Users/wm";
    shell = pkgs.zsh;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;
}
