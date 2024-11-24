{
  pkgs,
  lib,
  ...
}: let
  tmux_rose_pine = builtins.readFile ./tmux.conf;
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
      set-option -g default-shell ${pkgs.zsh}/bin/zsh

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
  ];

  xdg.configFile."tmux/scripts".source = ./scripts;
}
