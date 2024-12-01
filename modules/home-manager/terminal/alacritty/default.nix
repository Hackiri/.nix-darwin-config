{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.alacritty.enable = true;

  xdg.configFile."alacritty/alacritty.toml" = {
    source = ./alacritty.toml;
  };

  # Add macOS font smoothing setting
  home.file.".config/alacritty/macos.yml".text = ''
    font:
      use_thin_strokes: false
  '';

  # Add macOS specific application symlink
  home.activation = {
    copyAlacrittyMacOSApp = let
      apps = pkgs.buildEnv {
        name = "my-apps";
        paths = [pkgs.alacritty];
        pathsToLink = "/Applications";
      };
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        mkdir -p "$baseDir"
        for app in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$app")"
          $DRY_RUN_CMD rm -rf "$target"
          $DRY_RUN_CMD cp -rL "$app" "$target"
        done

        # Set macOS font smoothing
        defaults write org.alacritty AppleFontSmoothing -int 0
      '';
  };
}
