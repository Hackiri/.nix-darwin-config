{
  config,
  pkgs,
  lib,
  ...
}: let
  emacs-enabled = config.programs.emacs.enable;
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30; # Better macOS integration
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

  home = lib.mkIf emacs-enabled {
    packages = with pkgs; [
      emacs-all-the-icons-fonts
      ripgrep # For better search in projectile
      fd # For faster file finding
      shellcheck # For shell script checking
      nodePackages.prettier # For format-all
      nodePackages.typescript-language-server # For LSP
    ];

    file.".emacs.d" = {
      source = ./.emacs.d;
      recursive = true;
    };

    activation.copyEmacsMacOSApp = lib.hm.dag.entryAfter ["writeBoundary"] ''
      baseDir="$HOME/Applications/Home Manager Apps"
      mkdir -p "$baseDir"

      # Check if we have write permissions to the directory
      if [ -w "$baseDir" ]; then
        # Try to set permissions, but don't fail if it doesn't work
        chmod u+w "$baseDir" 2>/dev/null || true
      else
        echo "Warning: No write permission for $baseDir. Skipping chmod."
      fi

      for app in ${pkgs.emacs30}/Applications/*; do
        target="$baseDir/$(basename "$app")"

        # Check if target exists and is writable
        if [ -e "$target" ] && [ -w "$target" ]; then
          $DRY_RUN_CMD rm -rf "$target" || echo "Warning: Could not remove $target"
        elif [ -e "$target" ]; then
          echo "Warning: Cannot remove $target (permission denied). Skipping..."
          continue
        fi

        # Copy the application only if source exists
        if [ -e "$app" ]; then
          $DRY_RUN_CMD cp -rL "$app" "$target" || echo "Warning: Could not copy $app to $target"

          # Only try to set permissions if the copy succeeded and we have write access
          if [ -e "$target" ] && [ -w "$target" ]; then
            $DRY_RUN_CMD chmod -R u+w "$target" 2>/dev/null || echo "Warning: Could not set permissions on $target"
          fi
        fi
      done
    '';
  };
}
