return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        ["<CR>"] = cmp.config.disable,
      })

      opts.sources = {
        { name = "nvim_lsp", priority = 1000, group_index = 1 },
        { name = "luasnip", priority = 900, group_index = 2 },
        { name = "path", priority = 800, group_index = 2 },
        { name = "emoji", priority = 700, group_index = 3 },
        { name = "buffer", priority = 500, group_index = 3 },
        { name = "nvim_lua", priority = 400, group_index = 3 },
        { name = "codeium", priority = 200, group_index = 3 },
        { name = "copilot", priority = 100, group_index = 4 },
      }

      opts.sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }

      return opts
    end,
  },
}
