# Aggregates CLI tool modules for Home Manager
# Add additional CLI tool modules here as needed
{pkgs, ...}: let
  cliPackages = with pkgs; [
    shellcheck
    alejandra
    deadnix
    statix
    stylua
    devenv
    pre-commit
    gdb
    lldb
    viu
    bind
    omnictl
    talosctl
    terraform
    cilium-cli
    kustomize
    k9s
    kubectl
    kubecolor
    krew
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    kubernetes-helmPlugins.helm-secrets
    direnv
    fzf
    zoxide
    bat
    jq
    python3Packages.pygments
  ];
in {
  imports = [
    ./zoxide
    ./zellij
    ./bat
    ./gh
    ./eza.nix
    ./direnv.nix
    ./ripgrep.nix
    ./fd.nix
    ./jq.nix
    ./ssh.nix
    ./gpg.nix
    # Add more CLI tool modules here
  ];
  options.cliPackages = cliPackages;
}
