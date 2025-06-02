{inputs}: final: prev: {
  # Make stable packages available as pkgs.stable.*
  stable = import inputs.nixpkgs-stable {
    inherit (prev) system;
    config.allowUnfree = true;
  };
}