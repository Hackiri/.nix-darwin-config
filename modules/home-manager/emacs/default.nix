{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-macport; # Better macOS integration
    extraPackages = epkgs:
      with epkgs; [
        nix-mode
        nixpkgs-fmt
        flycheck
        json-mode
        python-mode
        auto-complete
        web-mode
        smart-tabs-mode
        whitespace-cleanup-mode
        flycheck-pyflakes
        flycheck-pos-tip
        nord-theme
        nordless-theme
        vscode-dark-plus-theme
        doom-modeline
        all-the-icons
        all-the-icons-dired
        magit
        markdown-mode
        markdown-preview-mode
        gptel
        yaml-mode
        multiple-cursors
        dts-mode
        rust-mode
        nickel-mode
        company
        projectile
        counsel
        ivy
        which-key
        rainbow-delimiters
        helpful
        format-all
        vterm
        treemacs
        lsp-mode
        lsp-ui
        dap-mode
        yasnippet
      ];
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    ripgrep # For better search in projectile
    fd # For faster file finding
    shellcheck # For shell script checking
    nodePackages.prettier # For format-all
    nodePackages.typescript-language-server # For LSP
  ];

  home.file.".emacs.d" = {
    source = ./.emacs.d;
    recursive = true;
  };

  # Add macOS specific application symlink
  home.activation = {
    copyEmacsMacOSApp = let
      apps = pkgs.buildEnv {
        name = "my-apps";
        paths = [pkgs.emacs29-macport];
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
      '';
  };
}
