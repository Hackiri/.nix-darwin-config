return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    operators = { gc = "Comments" },
    key_labels = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    popup_mappings = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    window = {
      border = "single",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    ignore_missing = false,
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
    show_help = true,
    show_keys = true,
    triggers = "auto",
    triggers_nowait = {
      -- marks
      "`",
      "'",
      "g`",
      "g'",
      -- registers
      '"',
      "<c-r>",
      -- spelling
      "z=",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Register all keymaps here to avoid duplicates
    wk.register({
      mode = { "n", "v" },
      ["<leader>b"] = { name = "+buffer" },
      ["<leader>f"] = { name = "+file/find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>q"] = { name = "+quit/session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>w"] = { name = "+window" },
      ["<leader>t"] = { name = "+toggle" },
      ["<leader>c"] = { name = "+code" },
      ["<leader>n"] = {
        name = "+neotree",
        g = {
          name = "+git",
          s = "Git status",
        },
      },
      ["<leader>m"] = {
        name = "+mini.files",
        m = "Open at current directory",
        M = "Open at current file",
      },
      ["\\"] = "Neo-tree current file",
      ["<leader>e"] = "Neo-tree toggle",
      ["g"] = { name = "+goto" },
      ["gs"] = { name = "+surround" },
      ["gz"] = { name = "+surround" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader>l"] = { name = "+lazy/mason" },
    })
  end,
}
