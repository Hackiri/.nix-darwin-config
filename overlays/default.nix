{inputs}: final: prev: let
  # Common configuration for package sets
  commonConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "terraform-1.9.8"
    ];
  };

  # Configure unstable with common config
  unstableConfig = {
    inherit (prev) system;
    config = commonConfig;
  };

  # Create unstable package set with config
  unstablePkgs = import inputs.nixpkgs unstableConfig;
in {
  # Make unstable packages available
  unstable = unstablePkgs;

  # Import the fix-types overlay
  inherit (import ./fix-types.nix final prev) lib;
  
  # Import the stable overlay
  inherit (import ./stable.nix {inherit inputs;} final prev) stable;

  # Kubernetes and related tools from unstable
  inherit
    (unstablePkgs)
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins
    k9s
    cilium-cli
    kustomize
    talosctl
    krew
    terraform
    ;
}
