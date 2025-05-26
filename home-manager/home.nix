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

  home = {
    username = "wm";
    homeDirectory = "/Users/wm";
    stateVersion = "24.05";
  };

  # Packages to be installed for the user
  # You can access overlays/default.nix packages and tools.
  home.packages = with pkgs; [
    # Moved from system configuration
    git
    zsh
    nix-direnv
    direnv

    # Existing packages
    customPkgs.dev-tools # Custom development helper scripts
    python3Packages.pygments
    python3Packages.pytest_7
    python3Packages.pylint
    python3Packages.markdown
    python3Packages.tabulate
    nixd
    kubectl
    k9s
    kubernetes-helm
    # Individual helm plugins instead of the whole set
    kubernetes-helmPlugins.helm-diff # Compare chart changes
    kubernetes-helmPlugins.helm-git # Git integration for Helm
    kubernetes-helmPlugins.helm-cm-push # Push charts to ChartMuseum
    kubernetes-helmPlugins.helm-secrets # Manage encrypted secrets
    kubernetes-helmPlugins.helm-s3 # S3 chart repository support
    kubernetes-helmPlugins.helm-unittest # Unit testing for charts
    kubernetes-helmPlugins.helm-mapkubeapis # Handle API version migrations
    cilium-cli
    kustomize
    talosctl
    krew
    terraform
  ];

  programs = {
    home-manager.enable = true;
    devshell.enable = true;
  };
}
