{
  pkgs,
  lib,
  ...
}: let
  tmux_rose_pine = builtins.readFile ./tmux.conf;

  truncate_path = pkgs.writeScriptBin "truncate_path" ''
    #!/bin/sh

    path="$1"
    max_length="''${2:-50}"  # Default to 50 if not specified
    user_home="/Users/wm"

    # Exit if no path is provided
    if [ -z "$path" ]; then
        echo "Usage: $0 <path> [max_length]"
        exit 1
    fi

    # Replace $user_home with ~ in the path
    path="''${path/#$user_home/\~}"

    # Truncate path if it's longer than max_length
    if [ "''${#path}" -gt "$max_length" ]; then
        # Keep the last $max_length characters
        path="...''${path:$(( ''${#path} - $max_length + 3 ))}"

        # Ensure we don't break directory separators
        if ! echo "$path" | grep -q "^/\|^\.\.\./" ; then
            path="''${path#*/}"
            path=".../$path"
        fi
    fi

    echo "$path"
  '';
in {
  imports = [];

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    baseIndex = 1;

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank # Copy to system clipboard
      tmuxPlugins.sensible # Sensible defaults
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      ${tmux_rose_pine}

      # Enable mouse support
      set -g mouse on

      # Set zsh as default shell
      set-option -g default-shell "${pkgs.zsh}/bin/zsh"

      # Better window splitting
      bind-key "|" split-window -h -c "#{pane_current_path}"
      bind-key "\\" split-window -fh -c "#{pane_current_path}"
      bind-key "-" split-window -v -c "#{pane_current_path}"
      bind-key "_" split-window -fv -c "#{pane_current_path}"

      # Keep current path when creating new windows
      bind c new-window -c "#{pane_current_path}"

      # Smart pane switching with awareness of Vim splits
      bind -n C-h run "tmux select-pane -L"
      bind -n C-j run "tmux select-pane -D"
      bind -n C-k run "tmux select-pane -U"
      bind -n C-l run "tmux select-pane -R"

      # Easy config reload
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."
    '';
  };

  home.packages = with pkgs; [
    tmux-sessionizer
    tmuxinator # For managing complex tmux sessions
    truncate_path
  ];
}
