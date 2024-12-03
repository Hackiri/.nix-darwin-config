{inputs}: {
  default = final: prev: let
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

    # Create neovim package set with config
    neovimPkgs = import inputs.neovim-overlay (final
      // {
        config =
          commonConfig
          // {
            allowBroken = true;
          };
      });
  in {
    # Make unstable packages available
    unstable = unstablePkgs;

    # Use neovim nightly from the overlay with minimal Python
    neovim-nightly = neovimPkgs.neovim;

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
      ;

    # Development tools from unstable
    inherit
      (unstablePkgs)
      vscode-langservers-extracted
      terraform
      gh
      ;
  };
}
