return {
  -- Mason configuration
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language servers that were previously in Nix config
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "eslint-lsp",
        "prettier",
        "tailwindcss-language-server",
        "yaml-language-server",
        "bash-language-server",
        "dockerfile-language-server",
        
        -- Additional useful tools
        "stylua",
        "shfmt",
        "shellcheck",
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  
  -- Mason LSP configuration
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Automatically set up LSP servers installed with Mason
      automatic_installation = true,
      
      -- Explicit server setup
      ensure_installed = {
        "tsserver",        -- TypeScript
        "html",            -- HTML
        "cssls",           -- CSS
        "jsonls",          -- JSON
        "eslint",          -- ESLint
        "tailwindcss",     -- Tailwind CSS
        "yamlls",          -- YAML
        "bashls",          -- Bash
        "dockerls",        -- Dockerfile
      },
    },
  },
}