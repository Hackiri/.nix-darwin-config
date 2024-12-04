{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Import the module that handles all other imports
  imports = [
    ../modules/home-manager
  ];

  fonts.fontconfig.enable = true;

  # Enable devshell
  programs.devshell.enable = true;

  home = {
    username = "wm";
    homeDirectory = "/Users/wm";
    stateVersion = "24.05";

    # Packages to be installed for the user
    packages = with pkgs; [
      # Development utilities
      pre-commit
      shellcheck
      alejandra
      deadnix
      statix
      stylua

      # Debugging and analysis
      gdb
      lldb

      # Network utilities
      bind # Provides dig command

      # Kubernetes and infrastructure tools
      omnictl
      talosctl
      terraform
      cilium-cli
      kustomize
      k9s
      kubectl
      kubecolor
      krew
      kubernetes-helm
      kubernetes-helmPlugins.helm-diff
      kubernetes-helmPlugins.helm-secrets
    ];

    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
  };

  programs = {
  };
}
