{
  # User configuration
  user = {
    name = "wm";
    home = "/Users/wm";
    email = "128340174+Hackiri@users.noreply.github.com";
    fullName = "hackiri";
  };

  # System configuration
  system = {
    hostName = "WMs-MacBook-Pro";  # Used in flake.nix for darwinConfigurations
    architecture = "x86_64-darwin";
    darwin = {
      trusted-users = ["root" "@admin" "wm"];
    };
  };

  # Development configuration
  dev = {
    editor = "nvim";
    shell = "zsh";
  };

  # Nix configuration
  nix = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    settings = {
      cores = 0;
      max-jobs = "auto";
      system-features = ["big-parallel"];
      download-buffer-size = 100000000;
    };
  };
}
