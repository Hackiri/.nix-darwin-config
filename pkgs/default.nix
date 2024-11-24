# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
# ./pkgs/default.nix
pkgs: {
  # Note: it's callPackage (lowercase 'c'), not CallPackage
  # neovim-nightly = pkgs.callPackage ./neovim-nightly.nix { };
}
