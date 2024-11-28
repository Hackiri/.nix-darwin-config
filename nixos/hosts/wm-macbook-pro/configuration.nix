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
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
      # Ensure proper clipboard support
      TERM = "xterm-256color";
    };
    systemPackages = with pkgs; [
      # Development tools
      git
      neovim
      tmux
      zsh
      wget
      curl
      htop
      tree
      ripgrep
      fd
      jq
      yq-go
      fzf
      bat
      eza
      nix-direnv
      direnv
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
      git-crypt
      pre-commit
      shellcheck
      nixpkgs-fmt
      alejandra
      deadnix
      statix
      mkalias
      pam-reattach
      obsidian
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
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
      user = "wm";
    };
    optimise = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
    };
  };

  # Enable touch ID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # System configuration
  system = {
    # Add pam-reattach to enable TouchID for tmux and set up applications
    activationScripts.postActivation.text = ''
        # Add pam_reattach to enable TouchID for tmux
        sudo mkdir -p /usr/local/lib/pam
        sudo cp ${pkgs.pam-reattach}/lib/pam/pam_reattach.so /usr/local/lib/pam/

        # Add pam_reattach to sudo config if not already present
        if ! grep -q "pam_reattach.so" /etc/pam.d/sudo; then
          sudo sed -i "" '2i\
      auth       optional     pam_reattach.so
      ' /etc/pam.d/sudo
        fi

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
          done
    '';

    defaults = {
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
      };
      loginwindow.GuestEnabled = false;
      screencapture.location = "~/Pictures/screenshots";
      screensaver.askForPasswordDelay = 10;
      dock = {
        autohide = true;
        mru-spaces = false;
        launchanim = false;
        minimize-to-application = false;
        show-recents = false;
        static-only = true;
        showhidden = true;
        persistent-apps = [
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "/Applications/Firefox.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
        ];
      };
    };

    configurationRevision = inputs.self.lastModifiedDate or inputs.self.lastModified or null;
    stateVersion = 4;
  };

  # Enable nix daemon service
  services.nix-daemon.enable = true;

  # Enable nix-index service to update nix packages
  programs.nix-index.enable = true;

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "hammerspoon"
      "firefox"
      "iina"
      "the-unarchiver"
      "wezterm"
      "wireshark"
      "raycast"
    ];
    masApps = {
    };
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
