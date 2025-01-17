-- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md

return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        theme = {
          selectedLineBgColor = { bg = "CursorLine" },
        },
      },
      notifier = {
        enabled = true,
        top_down = false, -- place notifications from top to bottom
      },
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            pane = 2,
            section = "terminal",
            title = "Git Status",
            icon = " ",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status -sb",
            height = 8,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            {
              icon = "󰒲 ",
              key = "x",
              desc = "Lazy Extras",
              action = ":LazyExtra",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "<esc>", desc = "Quit", action = ":qa" },
          },
          header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
  
          ]],
        },
      },
    },
  },
}
