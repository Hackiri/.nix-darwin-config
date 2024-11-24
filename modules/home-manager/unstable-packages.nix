{
  config,
  lib,
  pkgs,
  ...
}: {
  # Make unstable packages available through config
  config = {
    home.packages = let
      unstable = pkgs.unstable;
    in
      with unstable; [
        # Add any unstable packages you want available everywhere
      ];
  };
}
