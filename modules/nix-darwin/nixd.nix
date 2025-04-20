# nixd module for nix-darwin
# Adds nixd to system packages and sets nix.nixPath for unstable nixpkgs
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [pkgs.nixd];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs-unstable}"];
}
