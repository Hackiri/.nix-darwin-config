{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  customPkgs = import ../pkgs {inherit pkgs;};
in {
  # Import the module that handles all other imports
  imports = [
    ../modules/home-manager
  ];

  # Enable devshell

  home = {
    username = "wm";
    homeDirectory = "/Users/wm";
    stateVersion = "24.05";

    # Packages to be installed for the user
    packages = with pkgs; [
      customPkgs.dev-tools # Custom development helper scripts
      python3Packages.pygments
      nixd
    ];
  };

  programs = {
    # Git configuration can be added here
    eza = {
      enable = true;
    };
  };
}
