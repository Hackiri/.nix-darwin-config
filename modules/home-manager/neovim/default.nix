{
  config,
  lib,
  pkgs,
  ...
}: let
  mkEntryFromDrv = drv:
    if lib.isDerivation drv
    then {
      name = "${lib.getName drv}";
      path = drv;
    }
    else drv;

  plugins = with pkgs.vimPlugins; [
    # LazyVim Core
    LazyVim
    plenary-nvim
    nui-nvim
    nvim-web-devicons
    snacks-nvim

    # Navigation and Fuzzy Finding
    telescope-nvim
    telescope-fzf-native-nvim
    harpoon
    flash-nvim

    # LSP and Completion
    nvim-lspconfig
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    cmp_luasnip
    luasnip
    friendly-snippets
    fidget-nvim
    neodev-nvim
    neoconf-nvim

    # Treesitter
    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-treesitter-context
    nvim-ts-autotag
    nvim-ts-context-commentstring

    # Git
    lazygit-nvim
    gitsigns-nvim

    # UI Components
    lualine-nvim
    bufferline-nvim
    neo-tree-nvim
    alpha-nvim
    indent-blankline-nvim
    aerial-nvim
    noice-nvim
    nvim-spectre
    persistence-nvim
    vim-startuptime
    trouble-nvim
    todo-comments-nvim

    # Debugging
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-dap-go
    nvim-dap-python
    nvim-nio

    # Database
    vim-dadbod
    vim-dadbod-ui
    vim-dadbod-completion

    # Formatting and Linting
    conform-nvim
    nvim-lint

    # Editor Enhancement
    comment-nvim
    which-key-nvim
    vim-illuminate
    nvim-notify
    dressing-nvim
    zen-mode-nvim
    vim-repeat
    vim-sleuth
    noice-nvim
    tree-sitter-context
    codeium-nvim

    # Mini Plugins
    {
      name = "mini.ai";
      path = mini-nvim;
    }
    {
      name = "mini.bufremove";
      path = mini-nvim;
    }
    {
      name = "mini.comment";
      path = mini-nvim;
    }
    {
      name = "mini.files";
      path = mini-nvim;
    }
    {
      name = "mini.indentscope";
      path = mini-nvim;
    }
    {
      name = "mini.pairs";
      path = mini-nvim;
    }
    {
      name = "mini.surround";
      path = mini-nvim;
    }

    # Optional Plugins
    headlines-nvim
    obsidian-nvim
    markdown-preview-nvim
  ];

  lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
in {
  programs.neovim = {
    enable = true;
    extraLuaPackages = ps: [ps.magick]; # Add Lua magick package
    extraPackages = with pkgs; [
      git # Required for lazy.nvim bootstrap
      # Language Servers
      lua-language-server
      nil
      codeium
      ltex-ls
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # html, css, json, eslint
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.yaml-language-server
      nodePackages.graphql-language-service-cli
      python311Packages.python-lsp-server
      ruff-lsp
      rust-analyzer
      terraform-ls
      pyright
      gopls
      clang-tools
      cmake-language-server
      tailwindcss-language-server

      # Formatters and Linters
      stylua # Lua formatter
      black # Python formatter
      ruff # Python linter/formatter
      rustfmt # Rust formatter
      terraform # Terraform formatter
      alejandra # Nix formatter
      shellcheck # Shell script linter
      shfmt # Shell script formatter
      taplo # TOML formatter
      nodePackages.markdownlint-cli # Markdown linter
      nodePackages.prettier # JavaScript/TypeScript/CSS/HTML formatter

      # Debug Adapters
      lldb # For C/C++/Rust
      delve # For Go
      python311Packages.debugpy # For Python

      # Git and Tools
      lazygit
      gh # GitHub CLI

      # Search and Find
      ripgrep
      fd

      # Database Clients
      sqlite
      postgresql

      # Build Tools and Runtime
      nodejs_20
      nodePackages.npm
      nodePackages.node-gyp
      git
      gcc
      gnumake
      gdb
      cargo
      go

      # Additional Tools
      tree-sitter
      fzf
      universal-ctags
      nodePackages.yarn
      imagemagick # Required for image.nvim

      # Lua Development
      luarocks
      lua5_1
      pkg-config
    ];

    plugins = with pkgs.vimPlugins; [
      luasnip
    ];

    extraLuaConfig = ''
      -- Load lazy.nvim configuration
      require("config.lazy")
    '';
  };

  # Symlink Treesitter parsers
  home.file.".config/nvim/parser" = {
    source = let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths =
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
            with plugins; [
              c
              lua
              vim
              vimdoc
              query
              cpp
              rust
              python
              go
              javascript
              typescript
              html
              css
              json
              yaml
              toml
              bash
              nix
              markdown
              regex
              tsx
              sql
            ]))
          .dependencies;
      };
    in "${parsers}/parser";
  };

  # Symlink custom Lua configuration files
  home.file.".config/nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
}
