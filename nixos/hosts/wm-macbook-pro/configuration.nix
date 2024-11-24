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

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Ensure proper clipboard support
    TERM = "xterm-256color";
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "wm"];
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

  # System Packages
  environment.systemPackages = with pkgs; [
    mkalias
    obsidian
    pam-reattach
  ];

  # Enable touch ID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Add pam-reattach for TouchID support in tmux
  system.activationScripts.postActivation.text = ''
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

  # Enable nix daemon service.
  services.nix-daemon.enable = true;

  # Enable nix-index service to update nix packages
  programs.nix-index.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Declare the user that will be running `nix-darwin`.
  users.users.wm = {
    name = "wm";
    home = "/Users/wm";
    shell = pkgs.zsh;
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "FiraCode"
          "IBMPlexMono"
        ];
      })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    dock.orientation = "bottom";
    dock.persistent-apps = [
      "${pkgs.alacritty}/Applications/Alacritty.app"
      "/Applications/Firefox.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
    ];
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
  };
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
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
  nix-homebrew.user = "wm";

  # Set zsh as default shell globally
  environment.shells = [pkgs.zsh];

  # Enable zsh system-wide
  programs.zsh.enable = true;
}
