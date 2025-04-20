{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # Language servers
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier
      nodePackages."@tailwindcss/language-server"
      nodePackages.yaml-language-server
      # LSP servers
      python3Packages.python-lsp-server
      python3Packages.pynvim
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
      # Additional language servers
      clang-tools
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      marksman
      taplo
      # Development tools
      stylua
      black
      isort
      shellcheck
      statix
      alejandra

      # Plugins
      lynx
      luajitPackages.tiktoken_core
      pkgs.vimPlugins.luasnip # LuaSnip includes jsregexp functionality
      python3Packages.tiktoken # Add this for CopilotChat token counting
      python312Packages.pylatexenc
      wordnet # Add this for blink-cmp-dictionary word definitions
    ];

    extraLuaConfig = ''
      -- Set leader key before lazy
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Set up Python path for hererocks
      vim.g.python3_host_prog = "${pkgs.python3}/bin/python3"

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
