{ config, pkgs, theme, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "bg+" = theme.colors.bg_highlight;
      "fg+" = theme.colors.fg;
      "hl+" = theme.colors.blue;
      hl = theme.colors.blue;
      header = theme.colors.comment;
      info = theme.colors.cyan;
      marker = theme.colors.red;
      pointer = theme.colors.magenta;
      prompt = theme.colors.yellow;
      spinner = theme.colors.magenta;
    };
  };
}
