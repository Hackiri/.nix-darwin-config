-- Mason and LSP configuration
return {
  -- Mason package manager for external tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        -- Language servers that are installed via Mason (not Nix)
        "templ",
        "harper-ls",
        "typescript-language-server", -- Mason package name
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
      -- Configure path to Nix Python installation
      PATH = "append",
      -- Add your nix-darwin Python path
      -- This will make Mason use the Python from nix-darwin
      registries = {
        -- Override the default registry
        "github:mason-org/mason-registry",
      },
    },
    -- Set up Mason to use the nix-darwin Python
    config = function(_, opts)
      require("mason").setup(opts)

      -- Get the path to the nix-darwin Python
      local handle = io.popen("which python3")
      local python_path = handle:read("*a"):gsub("\n$", "")
      handle:close()

      -- Set the Python path for Mason
      vim.g.mason_python_executable = python_path

      -- Handle pip installation if needed
      local pip_check_cmd = python_path .. " -m pip --version 2>/dev/null || echo 'not found'"
      local pip_check = io.popen(pip_check_cmd)
      local pip_result = pip_check:read("*a")
      pip_check:close()

      if pip_result:match("not found") then
        -- Set alternative installation method for Python packages
        -- This tells Mason to use pip3 directly if available, or to skip Python-based tools
        vim.g.mason_pip_cmd = "pip3"

        -- Inform user about pip issue
        vim.notify(
          "Mason: pip not found in nix Python. Some Python-based tools may not install correctly.\n"
            .. "Consider adding 'python3-pip' to your nix packages.",
          vim.log.levels.WARN
        )
      end
    end,
  },

  -- Mason LSP configuration - bridges Mason with Neovim's LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- Automatically set up LSP servers installed with Mason
      automatic_installation = true,

      -- Map Mason package names to lspconfig server names
      handlers = {
        -- This is the default handler that will be called for each installed server
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,

        -- Special configuration for specific servers
        ["tsserver"] = function()
          require("lspconfig").tsserver.setup({
            -- TypeScript-specific settings
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
          })
        end,
      },
    },
  },
}
