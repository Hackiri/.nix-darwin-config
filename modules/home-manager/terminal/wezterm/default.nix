{
  config,
  lib,
  pkgs,
  ...
}: let
  weztermConfig = builtins.readFile ./main_config.lua;
in {
  imports = [];

  # Link wezterm configuration to the correct location for brew-installed wezterm
  xdg.configFile."wezterm/wezterm.lua".text = weztermConfig;
}
