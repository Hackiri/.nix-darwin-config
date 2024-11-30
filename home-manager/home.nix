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
      luarocks
      lua5_1
      stylua
      pkg-config
      imagemagick # for image processing
      file # for file type detection

      # Debugging and analysis
      gdb
      lldb

      # Kubernetes and infrastructure tools
      omnictl
      talosctl
      terraform
      cilium-cli
      kustomize
      k9s
      kubectl
      krew
      kubernetes-helm
      kubernetes-helmPlugins.helm-diff
      kubernetes-helmPlugins.helm-secrets
    ];

    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];

    file.".tokyoNightTheme".text = builtins.readFile "${inputs.tokyonight}/extras/sublime/tokyonight_night.tmTheme";
  };

  programs = {
    git = {
      enable = true;
      userName = builtins.getEnv "GIT_USER_NAME";
      userEmail = builtins.getEnv "GIT_USER_EMAIL";
    };
    home-manager.enable = true;

    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          UseKeychain yes
          AddKeysToAgent yes
      '';
      matchBlocks = {
        "*" = {
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };

    lazygit = {
      enable = true;
      package = pkgs.lazygit;
      settings = {
        gui = {
          theme = {
            lightTheme = false;
            activeBorderColor = ["green" "bold"];
            inactiveBorderColor = ["white"];
            selectedLineBgColor = ["default"];
          };
          showIcons = true;
          expandFocusedSidePanel = true;
        };
        git = {
          paging = {
            colorArg = "always";
            useConfig = true;
          };
          branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
        };
        os = {
          edit = "nvim {{filename}}";
        };
        keybinding = {
          universal = {
            quit = "q";
            return = "<esc>";
          };
        };
      };
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          ratio = [1 2 5];
        };
        flavor = "tokyo-night";
      };
    };

    bat = {
      enable = true;
      themes = {
        tokyo-night = {
          src = inputs.tokyonight;
          file = "extras/sublime/tokyonight_night.tmTheme";
        };
      };
      config = {
        theme = "tokyo-night";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
