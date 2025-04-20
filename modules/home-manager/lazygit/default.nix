{
  config,
  pkgs,
  ...
}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
          activeBorderColor = ["#50fa7b" "bold"];
          inactiveBorderColor = ["#44475a"];
          selectedLineBgColor = ["#8be9fd" "bold"];
        };
        showIcons = true;
        expandFocusedSidePanel = true;
      };
    };
  };
}
