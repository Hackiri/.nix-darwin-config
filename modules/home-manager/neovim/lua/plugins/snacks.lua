return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    -- Time in milliseconds that the notification will remain visible
    timeout = 3000,
    -- Maximum width of the notification
    max_width = 80,
    -- Maximum height of the notification
    max_height = nil,
    -- Minimum width of the notification
    min_width = 10,
    -- Whether to show the notification title
    show_title = true,
    -- Whether to show the notification icon
    show_icon = true,
    -- Position of the notification
    position = "top-right",
    -- Gap between notifications
    gap = 5,
    -- Custom highlight groups for different notification types
    highlights = {
      info = {
        title = { fg = "#61afef" },
        icon = { fg = "#61afef" },
        border = { fg = "#61afef" },
      },
      warn = {
        title = { fg = "#e5c07b" },
        icon = { fg = "#e5c07b" },
        border = { fg = "#e5c07b" },
      },
      error = {
        title = { fg = "#e06c75" },
        icon = { fg = "#e06c75" },
        border = { fg = "#e06c75" },
      },
      success = {
        title = { fg = "#98c379" },
        icon = { fg = "#98c379" },
        border = { fg = "#98c379" },
      },
    },
    -- Custom icons for different notification types
    icons = {
      info = "",
      warn = "",
      error = "",
      success = "",
    },
    -- Border style for notifications
    border = {
      style = "rounded",
      padding = { 0, 1 },
    },
    -- Animation settings
    animation = {
      -- Animation duration in milliseconds
      duration = 150,
      -- Animation fps
      fps = 60,
      -- Animation easing function
      easing = "in-out-sine",
    },
    -- Custom filter function for notifications
    filter = function(notification)
      -- Example: Filter out debug notifications in production
      if vim.env.PRODUCTION and notification.level == "debug" then
        return false
      end
      return true
    end,
  },
  -- Key mappings for quick actions
  keys = {
    {
      "<leader>sn",
      function()
        require("snacks").success("Task completed successfully!", {
          title = "Success",
          timeout = 2000,
        })
      end,
      desc = "Show success notification",
    },
    {
      "<leader>se",
      function()
        require("snacks").error("An error occurred!", {
          title = "Error",
          timeout = 4000,
        })
      end,
      desc = "Show error notification",
    },
  },
}
