# Home Manager module for font configuration
{ pkgs, ... }: {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.blex-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };
}

