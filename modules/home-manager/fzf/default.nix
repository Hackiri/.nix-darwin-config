{
  config,
  pkgs,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "bg+" = "#282a36";
      "fg+" = "#f8f8f2";
      "hl+" = "#8be9fd";
      hl = "#8be9fd";
      header = "#6272a4";
      info = "#8be9fd";
      marker = "#ff5555";
      pointer = "#bd93f9";
      prompt = "#f1fa8c";
      spinner = "#bd93f9";
    };
  };
}
