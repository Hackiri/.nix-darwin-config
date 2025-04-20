{ config, pkgs, theme, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
          activeBorderColor = [theme.colors.green "bold"];
          inactiveBorderColor = [theme.colors.fg_dark];
          selectedLineBgColor = [theme.colors.blue0 "bold"];
        };
        showIcons = true;
        expandFocusedSidePanel = true;
      };
    };
  };
}
