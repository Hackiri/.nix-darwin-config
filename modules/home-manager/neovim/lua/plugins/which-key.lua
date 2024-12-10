return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    window = {
      border = "single",
      padding = { 2, 2, 2, 2 },
    },
    operators = { 
      gc = "Comments",
      gb = "Block comment"
    },
    key_labels = {
      ["<leader>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    wk.register({
      ["<leader>f"] = { name = "+find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>l"] = { name = "+lsp" },
      ["<leader>s"] = { name = "+surround" },
    })
  end,
}
