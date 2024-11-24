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
    kubectl = unstablePkgs.kubectl;
    kubernetes-helm = unstablePkgs.kubernetes-helm;
    kubernetes-helmPlugins = unstablePkgs.kubernetes-helmPlugins;
    k9s = unstablePkgs.k9s;
    cilium-cli = unstablePkgs.cilium-cli;
    kustomize = unstablePkgs.kustomize;
    talosctl = unstablePkgs.talosctl;
    krew = unstablePkgs.krew;

    # Development tools from unstable
    vscode-langservers-extracted = unstablePkgs.vscode-langservers-extracted;
    terraform = unstablePkgs.terraform;
    gh = unstablePkgs.gh;
  };
}
