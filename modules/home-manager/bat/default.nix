{
  config,
  pkgs,
  theme,
  inputs,
  ...
}: {
  programs.bat = {
    enable = true;
    themes = {
      tokyo-night = {
        src = inputs.tokyonight;
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
    config = {
      theme = "tokyo-night";
      style = "numbers,changes,header";
      color = "always";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };
}
