return {
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
        autocomplete = { cmp.TriggerEvent.InsertEnter, cmp.TriggerEvent.TextChanged },
        trigger_characters = { ".", ":", "@", "/", "_" },
      },

      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          scrollbar = true,
          scrolloff = 2,
          col_offset = 0,
          side_padding = 1,
          max_height = 20,
          max_width = 80,
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
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
          symbol_map = { supermaven = " " },
          menu = {
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
            path = "[Path]",
            cmdline = "[Cmd]",
          },
          before = function(entry, vim_item)
            vim_item.menu = entry.source.name
            return vim_item
          end,
        }),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
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
      }),

      -- sources for autocompletion
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          priority = 1000,
          entry_filter = function(entry)
            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
          end,
        },
        {
          name = "supermaven",
        },
        {
          name = "luasnip",
          priority = 750,
          option = { show_autosnippets = true },
        },
        {
          name = "buffer",
          priority = 500,
          option = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "path", priority = 250 },
      }),

      experimental = {
        ghost_text = true,
      },

      -- Required fields for NixOS compatibility
      performance = {
        debounce = 60,
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
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
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

    -- Autocommands for enhanced completion
    vim.api.nvim_create_autocmd("TextChangedI", {
      pattern = "*",
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)[2]
        local current = string.sub(line, cursor, cursor)
        local prev_char = cursor > 1 and string.sub(line, cursor - 1, cursor - 1) or ""

        if current:match("%w") or prev_char:match("%s") or prev_char:match("[%.%:%@%/%_]") then
          cmp.complete()
        end
      end,
    })

    -- Cmdline completion trigger
    vim.api.nvim_create_autocmd("CmdlineChanged", {
      pattern = "*",
      callback = function()
        cmp.complete()
      end,
    })

    -- Highlights for Tokyonight theme
    local highlights = {
      CmpItemAbbrDeprecated = { fg = "#808080", strikethrough = true },
      CmpItemAbbrMatch = { fg = "#89ddff", bold = true },
      CmpItemAbbrMatchFuzzy = { fg = "#89ddff", bold = true },
      CmpItemMenu = { fg = "#bb9af7" },
      CmpItemKindVariable = { fg = "#9d7cd8" },
      CmpItemKindInterface = { fg = "#89ddff" },
      CmpItemKindText = { fg = "#9ece6a" },
      CmpItemKindFunction = { fg = "#7aa2f7" },
      CmpItemKindMethod = { fg = "#7aa2f7" },
      CmpItemKindKeyword = { fg = "#bb9af7" },
      CmpItemKindProperty = { fg = "#73daca" },
      CmpItemKindUnit = { fg = "#ff9e64" },
      PmenuSel = { bg = "#364A82" },
      Pmenu = { bg = "#24283b" },
      CmpBorder = { fg = "#89ddff" },
      CmpDocBorder = { fg = "#89ddff" },
    }

    for group, hl in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, hl)
    end

    -- Set general completion options
    vim.opt.shortmess:append("c")
    vim.opt.updatetime = 100
    vim.opt.timeoutlen = 300
  end,
}
