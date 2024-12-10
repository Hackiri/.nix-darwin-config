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

        -- Keep your existing keymaps but reorganize under <leader>l prefix
        map("<leader>ld", require("telescope.builtin").lsp_definitions, "[L]SP [D]efinition")
        map("<leader>lr", require("telescope.builtin").lsp_references, "[L]SP [R]eferences")
        map("<leader>li", require("telescope.builtin").lsp_implementations, "[L]SP [I]mplementation")
        map("<leader>lt", require("telescope.builtin").lsp_type_definitions, "[L]SP [T]ype Definition")
        map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[L]SP Document [S]ymbols")
        map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[L]SP [W]orkspace Symbols")
        map("<leader>ln", vim.lsp.buf.rename, "[L]SP Re[n]ame")
        map("<leader>la", vim.lsp.buf.code_action, "[L]SP Code [A]ction")
        map("<leader>lk", vim.lsp.buf.hover, "[L]SP Hover Documentation")
        map("<leader>lD", vim.lsp.buf.declaration, "[L]SP [D]eclaration")
        map("<leader>lwa", vim.lsp.buf.add_workspace_folder, "[L]SP [W]orkspace [A]dd Folder")
        map("<leader>lwr", vim.lsp.buf.remove_workspace_folder, "[L]SP [W]orkspace [R]emove Folder")
        map("<leader>lwl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[L]SP [W]orkspace [L]ist Folders")

        -- Format on save if the client supports it
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("format_on_save" .. event.buf, { clear = true }),
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end

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
      cmd = { "rustup", "run", "stable", "rust-analyzer" },
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            features = "all",
          },
          checkOnSave = true,
          check = {
            command = "clippy",
          },
          procMacro = {
            enable = true,
          },
        },
      },
    })

    -- TypeScript/JavaScript
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      init_options = {
        preferences = {
          disableSuggestions = true,
        },
      },
    })

    -- Other servers with basic setup
    local servers = {
      "html",
      "dockerls",
      "docker_compose_language_service",
      "ruff",
      "tailwindcss",
      "taplo",
      "jsonls",
      "sqlls",
      "terraformls",
      "yamlls",
      "bashls",
      "graphql",
      "cssls",
      "texlab",
      "nixd",
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
      cmd = { "ltex-ls" },
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
      severity_sort = true,
    })
  end,
}
