return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    notify = {
      enabled = true,
      timeout = 3000,
      max_width = 80,
      max_height = nil,
      min_width = 10,
      show_title = true,
      show_icon = true,
      position = "top-right",
      gap = 5,
      highlights = {
        info = {
          title = { fg = "#7aa2f7" }, -- Tokyo Night blue
          icon = { fg = "#7aa2f7" },
          border = { fg = "#7aa2f7" },
        },
        warn = {
          title = { fg = "#e0af68" }, -- Tokyo Night yellow
          icon = { fg = "#e0af68" },
          border = { fg = "#e0af68" },
        },
        error = {
          title = { fg = "#f7768e" }, -- Tokyo Night red
          icon = { fg = "#f7768e" },
          border = { fg = "#f7768e" },
        },
        success = {
          title = { fg = "#9ece6a" }, -- Tokyo Night green
          icon = { fg = "#9ece6a" },
          border = { fg = "#9ece6a" },
        },
      },
      icons = {
        info = "",
        warn = "",
        error = "",
        success = "",
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      animation = {
        duration = 150,
        fps = 60,
        easing = "in-out-sine",
      },
      filter = function(notification)
        if vim.env.PRODUCTION and notification.level == "debug" then
          return false
        end
        return true
      end,
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
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { section = "startup" },
      },
      highlights = {
        header = { fg = "#7aa2f7" }, -- Tokyo Night blue
        icon = { fg = "#bb9af7" }, -- Tokyo Night purple
        title = { fg = "#7dcfff" }, -- Tokyo Night cyan
        key = { fg = "#e0af68" }, -- Tokyo Night yellow
        dir = { fg = "#9ece6a" }, -- Tokyo Night green
        file = { fg = "#c0caf5" }, -- Tokyo Night foreground
      },
    },
  },
  keys = {
    {
      "<leader>xs",
      function()
        require("snacks").success("Task completed successfully!", {
          title = "Success",
          timeout = 2000,
        })
      end,
      desc = "Show Success Notification",
    },
    {
      "<leader>xe",
      function()
        require("snacks").error("An error occurred!", {
          title = "Error",
          timeout = 3000,
        })
      end,
      desc = "Show Error Notification",
    },
    {
      "<leader>xw",
      function()
        require("snacks").warn("Warning: Proceed with caution", {
          title = "Warning",
          timeout = 3000,
        })
      end,
      desc = "Show Warning Notification",
    },
    {
      "<leader>xi",
      function()
        require("snacks").info("Here's some information", {
          title = "Info",
          timeout = 3000,
        })
      end,
      desc = "Show Info Notification",
    },
    {
      "<leader>xc",
      function()
        require("snacks").dismiss_all()
      end,
      desc = "Clear All Notifications",
    },
  },
}
