{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.neobean;
  # Using system-wide Python package
in {
  options.modules.neobean = {
    enable = mkEnableOption "neobean";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;

      extraPackages = with pkgs; [
        # Python LSP server
        python312Packages.python-lsp-server
        rust-analyzer
        lua-language-server
        luaformatter
        nil
        nixd
        gopls
        terraform-ls
        tflint
        ltex-ls
        git
        ripgrep
        fd
        htmx-lsp
        tree-sitter
        pkg-config
        luarocks
        lua5_1
        luajit
        lua51Packages.luafilesystem
        lua51Packages.luasocket
        lua51Packages.luv
        lua51Packages.lpeg
        lua51Packages.mpack
        # Additional language servers
        clang-tools
        marksman
        taplo
        # Development tools
        stylua
        black
        isort
        shellcheck
        statix
        alejandra

        # Debugging tools
        # Node.js debugging - using vscode-js-debug instead
        delve # Go debugging
        lldb # C/C++/Rust debugging

        # Image and document rendering tools
        imagemagick # Provides magick/convert for image conversion
        ghostscript # Provides gs for PDF rendering
        tectonic # LaTeX rendering
        mermaid-cli # Provides mmdc for Mermaid diagrams
        pngpaste # For img-clip.nvim clipboard image pasting

        # Plugins
        lynx
        luajitPackages.tiktoken_core
        luajitPackages.jsregexp
        python312Packages.tiktoken # For CopilotChat token counting
        python312Packages.pylatexenc
        wordnet # For blink-cmp-dictionary word definitions
      ];

      plugins = with pkgs.vimPlugins; [
        # Required for Codeium integration
        plenary-nvim
        lazy-nvim
      ];

      extraLuaConfig = ''
        -- Set leader key before lazy
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        -- Use system Python with pynvim for Neovim Python provider
        vim.g.python3_host_prog = "/etc/profiles/per-user/wm/bin/python3"

        -- Capture neovim_mode from environment variable
        vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"
        vim.g.md_heading_bg = vim.env.MD_HEADING_BG

        -- Load configuration
        require("config.lazy")
      '';
    };

    # Symlink original configuration files
    xdg.configFile = {
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua" = {
        source = ./lua;
        recursive = true;
      };
    };
  };
}
