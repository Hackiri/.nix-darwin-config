{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  # Import other NixOS modules here
  imports = [
    # ../../../modules/nix-darwin/default.nix
  ];

  environment = {
    variables = {
      # Ensure proper color support for terminals
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
    };

    systemPackages = with pkgs; [
      # System utilities
      mkalias
      pam-reattach

      # System tools
      git
      zsh
      nix-direnv
      direnv

      # CLI tools for formatting, linting, etc.
      alejandra
      deadnix
      statix
      stylua
    ];

    shells = [pkgs.zsh];

    # Add Docker aliases for Podman
    shellAliases = {
      docker = "podman";
      "docker-compose" = "podman-compose";
    };
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      trusted-users = ["root" "@admin" "wm"];
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Enable touch ID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # System configuration
  system = {
    # Configure defaults
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        NSDocumentSaveNewDocumentsToCloud = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      screencapture.location = "~/Pictures/Screenshots";
      screensaver.askForPasswordDelay = 10;
      dock = {
        autohide = true;
      };
    };

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
        # Set up applications
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        }}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          if [ -e "$HOME/Applications/Home Manager Apps/$app_name" ]; then
            echo "linking Home Manager app: $app_name" >&2
            ${pkgs.mkalias}/bin/mkalias "$HOME/Applications/Home Manager Apps/$app_name" "/Applications/Nix Apps/HM_$app_name"
          fi
        done
      '';

      postUserActivation.text = ''
        # Disable spotlight indexing
        echo "disabling spotlight indexing..." >&2
        mdutil -i off -d / &>/dev/null || true
      '';

      # Add Podman Docker compatibility setup
      podmanDockerCompat = {
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

                    echo "Remember to run 'podman machine init && podman machine start' to initialize the Podman machine" >&2
        '';
      };
    };

    stateVersion = 5;
  };

  # Enable nix-index service to update nix packages
  programs.nix-index.enable = true;

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
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  nix-homebrew.user = "wm";

  # Enable zsh system-wide
  programs.zsh.enable = true;

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
