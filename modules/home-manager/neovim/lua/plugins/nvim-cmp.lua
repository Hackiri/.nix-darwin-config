return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { 
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        -- Disable enter to prevent accidental completion acceptance
        ["<CR>"] = cmp.config.disable,
      })
      -- Adjust source priorities, I always want my luasnip snippets to show
      -- before copilot      
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      -- Configure sources with priorities
      opts.sources = {
        -- LSP has highest priority
        { name = "nvim_lsp", priority = 1000, group_index = 1 },
        -- Snippets second
        { name = "luasnip", priority = 900, group_index = 2 },
        -- Path completion
        { name = "path", priority = 800, group_index = 2 },
        -- Emoji support
        { name = "emoji", priority = 700, group_index = 3 },
        -- Buffer words
        { name = "buffer", priority = 500, group_index = 3 },
        -- Finally, the default source
        { name = "nvim_lua", priority = 400, group_index = 3 },
        -- Codeium
        { name = "codeium", priority = 200, group_index = 3 },
        -- Copilot
        { name = "copilot", priority = 100, group_index = 4 },
      }

      -- Enhanced sorting
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }
    end,
  },
}
