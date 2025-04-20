{
  config,
  lib,
  pkgs,
  ...
}:
# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  imports = [
    ./cli
    ./devshell
    ./emacs
    ./lazygit
    ./yazi
    ./fzf
    ./bat
    ./tmux
    ./terminal
    ./starship
    ./neovim
    ./fonts
    ./session
    ./git
  ];
}
