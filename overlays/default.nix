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
  unstablePkgs = import inputs.nixpkgs-unstable unstableConfig;
in {
  # Make unstable packages available
  unstable = unstablePkgs;

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
