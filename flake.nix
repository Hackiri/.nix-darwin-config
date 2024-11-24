{
  description = "Nix Flake configuration";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    alejandra.url = "github:kamadorueda/alejandra";
    nixd.url = "github:nix-community/nixd";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs-unstable";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    download-buffer-size = 100000000; # Increase download buffer size
    system-features = ["big-parallel"]; # Enable parallel builds
    max-jobs = "auto"; # Allow maximum parallel jobs
    cores = 0; # Use all available cores
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              prettier = prev.nodePackages.prettier;
            })
          ];
        };

        formatter = inputs.alejandra.defaultPackage.${system};

        devShells.default = let
          # Create a minimal home-manager configuration
          homeManagerModule = {
            config,
            lib,
            pkgs,
            ...
          }: {
            imports = [
              ./modules/home-manager/devshell/default.nix
            ];

            # Add these required options for home-manager modules
            home = {
              username = "wm"; # Replace with your username
              homeDirectory = "/Users/wm"; # Replace with your home directory
              stateVersion = "24.05";
              packages = [];
            };

            programs.devshell.enable = true;
          };

          # Evaluate the home-manager configuration using home-manager's lib
          evalModule = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [homeManagerModule];
            extraSpecialArgs = {inherit pkgs;};
          };

          # Extract configuration from evaluated module
          hmConfig = evalModule.config;
        in
          pkgs.mkShell {
            packages = hmConfig.home.packages;

            shellHook = ''
              # Set environment variables from home-manager config
              ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (name: value: "export ${name}=${value}") hmConfig.home.sessionVariables))}

              # Add session paths
              export PATH="${builtins.concatStringsSep ":" hmConfig.home.sessionPath}:$PATH"

              # Run the activation script parts that are relevant for the shell
              ${hmConfig.home.activation.createDevDirs.data}

              # Source the shell configuration from devshell module
              ${hmConfig.programs.devshell.shellConfig}
            '';
          };
      };

      flake = let
        mkOverlay = system: final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          prettier = prev.nodePackages.prettier;
        };
      in {
        darwinModules = import ./modules/nix-darwin;
        packages = import ./pkgs {inherit inputs;};

        darwinConfigurations = let
          mkDarwinConfig = {
            system,
            nixpkgs ? inputs.nixpkgs,
            baseModules ? [],
            ...
          }:
            inputs.nix-darwin.lib.darwinSystem {
              inherit system;
              modules =
                [
                  ./nixos/hosts/wm-macbook-pro/configuration.nix
                  ./home-manager/home.nix
                  inputs.home-manager.darwinModules.home-manager
                  inputs.nix-homebrew.darwinModules.nix-homebrew
                  ({
                    config,
                    pkgs,
                    lib,
                    ...
                  }: {
                    nixpkgs.overlays = [
                      (import ./overlays {inherit inputs;}).default
                    ];
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      verbose = true;
                    };
                    nix-homebrew = {
                      enable = true;
                      enableRosetta = false;
                      autoMigrate = true;
                    };
                    nix = {
                      settings = {
                        experimental-features = [
                          "nix-command"
                          "flakes"
                          "ca-derivations"
                        ];
                        trusted-users = ["root" "@admin" "wm"];
                        warn-dirty = false; # Suppress dirty git tree warnings
                      };
                      gc = {
                        automatic = true;
                        interval = {
                          Weekday = 0;
                          Hour = 2;
                          Minute = 0;
                        }; # Run before optimize
                        options = "--delete-older-than 30d";
                        user = "wm";
                      };
                      optimise = {
                        automatic = true;
                        interval = {
                          Weekday = 0;
                          Hour = 3;
                          Minute = 0;
                        }; # Run after GC
                        user = "wm";
                      };
                    };
                  })
                ]
                ++ baseModules;
              specialArgs = {
                inherit inputs system;
                pkgs = import inputs.nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                  overlays = [
                    (import ./overlays {inherit inputs;}).default
                  ];
                };
              };
            };
        in {
          "WMs-MacBook-Pro" = mkDarwinConfig {
            system = "x86_64-darwin";
            baseModules = [];
          };
        };
      };
    };
}
