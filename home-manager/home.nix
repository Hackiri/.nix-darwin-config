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
      devenv
      customPkgs.dev-tools # Custom development helper scripts

      # Debugging and analysis
      gdb
      lldb
      viu

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
