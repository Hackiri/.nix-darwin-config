return {
  "stevearc/oil.nvim",
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {},
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["v"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
        ["s"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
        ["t"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
        ["p"] = "actions.preview",
        ["q"] = "actions.close",
        ["r"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["cd"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" } },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["gh"] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      float = {
        padding = 3,
        border = "rounded",
      },
    })
  end,
}
