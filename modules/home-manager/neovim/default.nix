{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # No imports needed

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # LSP servers
      python3Packages.python-lsp-server
      python3Packages.pynvim
      python3Packages.pip
      python3Packages.tiktoken # Add this for CopilotChat token counting
      python312Packages.pylatexenc
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
      luajitPackages.tiktoken_core
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
      vscode-js-debug

      # Debugging tools
      # Node.js debugging - using vscode-js-debug instead
      delve # Go debugging

      # Image and document rendering tools
      imagemagick # Provides magick/convert for image conversion
      ghostscript # Provides gs for PDF rendering
      tectonic # LaTeX rendering
      mermaid-cli # Provides mmdc for Mermaid diagrams
      pngpaste # For img-clip.nvim clipboard image pasting

      # Plugins
      lynx
      wordnet # Add this for blink-cmp-dictionary word definitions
    ];

    extraLuaConfig = ''
      -- Set leader key before lazy
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Use system Python
      -- vim.g.python3_host_prog is not set, so Neovim will find Python in PATH

      -- Capture neovim_mode from environment variable
      vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"
      vim.g.md_heading_bg = vim.env.MD_HEADING_BG

      -- Load lazy.nvim configuration
      require("config.lazy")

      -- Load your Lua configuration
      require("config")
    '';
  };

  # Symlink custom Lua configuration files
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
