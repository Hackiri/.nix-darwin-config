{
  description = "Nix Flake configuration";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    alejandra.url = "github:kamadorueda/alejandra";
    nixd.url = "github:nix-community/nixd";
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-compat.follows = "flake-compat";
      };
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
    download-buffer-size = 100000000;
    system-features = ["big-parallel"];
    max-jobs = "auto";
    cores = 0;
  };

  outputs = inputs @ {
    self,
    nixpkgs-unstable,
    nix-darwin,
    home-manager,
    ...
  }: let
    inherit (nixpkgs-unstable) lib;
    system = "x86_64-darwin";
    overlays = [
      (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      })
      (import ./overlays {inherit inputs;})
      (final: prev: {
        customPkgs = import ./pkgs {pkgs = prev;};
      })
    ];
    pkgs = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      inherit overlays;
    };
  in {
    darwinConfigurations = {
      "WMs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
          ./nixos/hosts/wm-macbook-pro/configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.wm = import ./home-manager/home.nix;
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        zsh
      ];
      shellHook = ''
        export SHELL="${pkgs.zsh}/bin/zsh"
        exec ${pkgs.zsh}/bin/zsh
      '';
    };
  };
}
