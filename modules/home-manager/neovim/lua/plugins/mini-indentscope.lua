return {
  "echasnovski/mini.indentscope",
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = "LazyFile",
  opts = {
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
  },
  config = function(_, opts)
    require("mini.indentscope").setup(opts)

    -- Add indent motion keybindings
    vim.keymap.set("n", "]]", function() require("mini.indentscope").goto_next() end, { desc = "Go to Next Indent" })
    vim.keymap.set("n", "[[", function() require("mini.indentscope").goto_prev() end, { desc = "Go to Prev Indent" })
    vim.keymap.set("o", "]]", function() require("mini.indentscope").textobject() end, { desc = "Select Indent Scope" })
    vim.keymap.set("o", "[[", function() require("mini.indentscope").textobject(true) end, { desc = "Select Indent Scope (Backwards)" })
  end,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "alpha",
        "dashboard",
        "fzf",
        "help",
        "lazy",
        "lazyterm",
        "mason",
        "neo-tree",
        "notify",
        "toggleterm",
        "Trouble",
        "trouble",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
