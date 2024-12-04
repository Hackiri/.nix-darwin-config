{ config, lib, pkgs, ... }: {
  imports = [];

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  # Link zellij configuration
  # xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}