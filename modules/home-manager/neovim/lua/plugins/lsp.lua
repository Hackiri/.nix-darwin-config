return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Useful status updates for LSP
    {
      "j-hui/fidget.nvim",
      tag = "v1.4.0",
      opts = {
        progress = {
          display = {
            done_icon = "✓",
          },
        },
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },
  },
  config = function()
    -- Load folding module
    local folding = nil
    pcall(function()
      folding = require("config.folding")
    end)

    -- LSP Attach Keybindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        -- Enable LSP folding for specific servers that should override treesitter
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if folding and client and client.name == "lua_ls" then -- Add more servers as needed
          folding.enable_lsp_folding(event.buf)
        end

        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- Keep your existing keymaps
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        map("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        -- Document highlight
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- LSP Server Configurations
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Server Configurations
    local lspconfig = require("lspconfig")

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = {
              "${3rd}/luv/library",
              unpack(vim.api.nvim_get_runtime_file("", true)),
            },
          },
          completion = {
            callSnippet = "Replace",
          },
          telemetry = { enable = false },
          diagnostics = { disable = { "missing-fields" } },
        },
      },
    })

    -- Python
    lspconfig.pylsp.setup({
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            mccabe = { enabled = false },
            pylsp_mypy = { enabled = false },
            pylsp_black = { enabled = false },
            pylsp_isort = { enabled = false },
          },
        },
      },
    })

    -- Rust
    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            features = "all",
          },
          checkOnSave = true,
          check = {
            command = "clippy",
          },
        },
      },
    })

    -- Other servers with basic setup
    local servers = {
      "html",
      "tsserver",
      "dockerls",
      "docker_compose_language_service",
      "ruff",
      "tailwindcss",
      "jsonls",
      "sqlls",
      "terraformls",
      "yamlls",
      "bashls",
      "graphql",
      "cssls",
      "ltex", -- Will be configured separately below
      "texlab",
      "nixd", -- Added nixd LSP
    }

    -- Setup basic servers
    for _, server in ipairs(servers) do
      if server ~= "ltex" then -- Skip ltex as it has special configuration
        lspconfig[server].setup({
          capabilities = capabilities,
        })
      end
    end

    -- LTeX specific configuration
    lspconfig.ltex.setup({
      capabilities = capabilities,
      cmd = { "ltex-ls" }, -- This should be available through Nix
      filetypes = { "text", "markdown", "tex", "latex" },
      flags = { debounce_text_changes = 300 },
      settings = {
        ltex = {
          language = "en-US",
          additionalRules = {
            enablePickyRules = true,
            motherTongue = "en-US",
          },
          disabledRules = {},
          dictionary = {},
        },
      },
    })

    -- Configure diagnostics
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        format = function(diagnostic)
          local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
          return string.format("%s %s", code, diagnostic.message)
        end,
      },
      float = {
        source = "always",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
    })
  end,
}
