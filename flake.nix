{
  description = "Nix Flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";  # Use nixpkgs-unstable for compatibility with nix-darwin
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";  # Stable Nix 25.05 for Darwin
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    download-buffer-size = 200000000;
    system-features = ["big-parallel"];
    max-jobs = "auto";
    cores = 0;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-darwin,
    home-manager,
    ...
  }: let
    inherit (nixpkgs) lib;
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    allSystems = linuxSystems ++ darwinSystems;
    forAllSystems = f: lib.genAttrs allSystems f;
    overlaysFor = system: [
      (final: prev: {
        unstable = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      })
      (import ./overlays {inherit inputs;})
      (final: prev: {
        # Import custom packages
        customPkgs = import ./pkgs {pkgs = prev;};
      })
    ];
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlaysFor system;
      };
  in {
    darwinConfigurations = {
      "WMs-MacBook-Pro" = let
        system = "x86_64-darwin";
        overlays = overlaysFor system;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          inherit overlays;
        };
      in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            home-manager.darwinModules.home-manager
            inputs.nix-homebrew.darwinModules.nix-homebrew
            ./nixos/hosts/wm-macbook-pro/configuration.nix
            # Modularized Homebrew integration
            {
              nix-homebrew = {
                user = "wm";
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                };
                # Enable these settings to fully let nix-darwin manage Homebrew
                mutableTaps = true;
                autoMigrate = true; # Automatically migrate your existing Homebrew packages
              };
            }
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
    devShells = forAllSystems (system: let
      pkgs = mkPkgs system;
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [zsh];
        shellHook = ''
          export SHELL="${pkgs.zsh}/bin/zsh"
          exec ${pkgs.zsh}/bin/zsh
        '';
      };
    });
  };
}
