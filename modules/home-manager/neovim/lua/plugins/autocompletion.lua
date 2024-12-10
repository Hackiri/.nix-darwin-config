return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "hrsh7th/cmp-nvim-lsp", -- source for LSP
      "hrsh7th/cmp-cmdline", -- source for cmdline
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for lua autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets library
      "onsails/lspkind.nvim", -- vs-code like pictograms
      "Exafunction/codeium.nvim", -- AI completion
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load VSCode-like snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      -- Helper function
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = {
          completeopt = "menu,menuone,preview,noselect",
          keyword_pattern = [[\k\+]],
          keyword_length = 1,
          autocomplete = false, -- Disable automatic completion
          trigger_characters = { ".", ":", "@", "/", "_" },
        },

        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            scrollbar = true,
            scrolloff = 2,
            col_offset = 0,
            side_padding = 1,
            max_height = 20,
            max_width = 80,
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            scrollbar = true,
            scrolloff = 2,
            col_offset = 0,
            side_padding = 1,
            max_height = 20,
            max_width = 80,
          }),
        },

        formatting = {
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true,
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Codeium = "󰚩 " },
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
              cmdline = "[Cmd]",
            },
          }),
        },

        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "codeium", priority = 900 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),

        -- Required fields for NixOS compatibility
        performance = {
          debounce = 30, -- Reduced for faster suggestions
          throttle = 30,
          fetching_timeout = 200,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          max_view_entries = 200,
          filtering_context_budget = 100,
        },

        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Changed to auto-select
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true }) -- Changed to confirm on Tab
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })

      -- Command line setup
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-n>"] = { c = cmp.mapping.select_next_item() },
          ["<C-p>"] = { c = cmp.mapping.select_prev_item() },
          ["<C-y>"] = { c = cmp.mapping.confirm({ select = true }) },
          ["<C-e>"] = { c = cmp.mapping.abort() },
        }),
        sources = cmp.config.sources({
          { name = "path", trigger_characters = { ".", "/", "~" } },
          { name = "cmdline", trigger_characters = { ":", "@", "-" } },
        }),
      })

      -- Search setup
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Set general completion options
      vim.opt.shortmess:append("c")
      vim.opt.updatetime = 100
      vim.opt.timeoutlen = 300
    end,
  },
}
