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
    ../../../modules/nix-darwin
  ];

  environment = {
    variables = {
      # Ensure proper clipboard support
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
    ];

    shells = [pkgs.zsh];
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
        auth       optional     pam_reattach.so
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
    ];
    casks = [
      "obsidian"
      "cmake"
      "docker"
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

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.blex-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
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
