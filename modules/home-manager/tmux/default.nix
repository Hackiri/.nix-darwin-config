{
  pkgs,
  lib,
  ...
}: let
  tmux_config = builtins.readFile ./tmux.conf;

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
    shell = "/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 1000000;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    baseIndex = 1;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      better-mouse-mode
      yank
      sensible
    ];

    extraConfig = ''
      ${tmux_config}
    '';
  };

  home.packages = with pkgs; [
    tmuxinator # For managing complex tmux sessions
    truncate_path
    moreutils # For sponge command used in tmux-resurrect
  ];
}
