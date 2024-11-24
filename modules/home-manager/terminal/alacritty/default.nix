{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        padding = {
          x = 5;
          y = 5;
        };
        decorations = "buttonless";
        startup_mode = "Maximized";
        dynamic_title = true;
        opacity = 0.95;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        size = 14.0;
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };

      # Rose Pine Theme
      colors = {
        primary = {
          background = "0x191724";
          foreground = "0xe0def4";
        };
        cursor = {
          text = "0x191724";
          cursor = "0xe0def4";
        };
        vi_mode_cursor = {
          text = "0x191724";
          cursor = "0xe0def4";
        };
        line_indicator = {
          foreground = "None";
          background = "None";
        };
        selection = {
          text = "0xe0def4";
          background = "0x403d52";
        };
        normal = {
          black = "0x26233a";
          red = "0xeb6f92";
          green = "0x31748f";
          yellow = "0xf6c177";
          blue = "0x9ccfd8";
          magenta = "0xc4a7e7";
          cyan = "0xebbcba";
          white = "0xe0def4";
        };
        bright = {
          black = "0x6e6a86";
          red = "0xeb6f92";
          green = "0x31748f";
          yellow = "0xf6c177";
          blue = "0x9ccfd8";
          magenta = "0xc4a7e7";
          cyan = "0xebbcba";
          white = "0xe0def4";
        };
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "#ffffff";
      };

      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
        save_to_clipboard = true;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        vi_mode_style = "Block";
        unfocused_hollow = true;
        thickness = 0.15;
      };

      general = {
        live_config_reload = true;
      };

      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = ["-l"];
      };

      mouse = {
        hide_when_typing = true;
        bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];
      };

      key_bindings = [
        {
          key = "V";
          mods = "Command";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Command";
          action = "Copy";
        }
        {
          key = "Q";
          mods = "Command";
          action = "Quit";
        }
        {
          key = "N";
          mods = "Command";
          action = "SpawnNewInstance";
        }
        {
          key = "Return";
          mods = "Command";
          action = "ToggleFullscreen";
        }
        {
          key = "F";
          mods = "Command|Control";
          action = "SearchForward";
        }
        {
          key = "B";
          mods = "Command|Control";
          action = "SearchBackward";
        }
        {
          key = "Key0";
          mods = "Command";
          action = "ResetFontSize";
        }
        {
          key = "Equals";
          mods = "Command";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Command";
          action = "DecreaseFontSize";
        }
      ];
    };
  };

  # Add macOS font smoothing setting
  home.file.".config/alacritty/macos.yml".text = ''
    font:
      use_thin_strokes: false
  '';

  # Add macOS specific application symlink
  home.activation = {
    copyAlacrittyMacOSApp = let
      apps = pkgs.buildEnv {
        name = "my-apps";
        paths = [pkgs.alacritty];
        pathsToLink = "/Applications";
      };
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        mkdir -p "$baseDir"
        for app in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$app")"
          $DRY_RUN_CMD rm -rf "$target"
          $DRY_RUN_CMD cp -rL "$app" "$target"
        done

        # Set macOS font smoothing
        defaults write org.alacritty AppleFontSmoothing -int 0
      '';
  };
}
