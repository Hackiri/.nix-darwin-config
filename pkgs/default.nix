# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
# ./pkgs/default.nix
_pkgs: {
  # Note: it's callPackage (lowercase 'c'), not CallPackage
  # example = _pkgs.callPackage ./example.nix { };
}
