-- supermaven.lua
return {
  {
    -- Supermaven plugin configuration
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          -- Changed from <Tab> to avoid conflict with nvim-cmp
          accept_suggestion = "<M-l>",
          clear_suggestion = "<M-]>",
          accept_word = "<M-j>",
        },
        ignore_filetypes = { cpp = true }, -- or { "cpp", }
        color = {
          suggestion_color = "#89B4FA", -- Catppuccin color for better visibility
          cterm = 244,
        },
        log_level = "info", -- set to "off" to disable logging completely
        disable_inline_completion = false, -- disables inline completion for use with cmp
        disable_keymaps = false, -- disables built in keymaps for more manual control
        condition = function()
          return false
        end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
        -- Additional options for better integration
        options = {
          debounce = 100, -- Reduce suggestion frequency
          min_word_length = 2, -- Minimum word length before suggesting
          max_suggestions = 3, -- Limit number of suggestions
          priority = 90, -- Lower than LSP but higher than buffer
        },
      })
    end,
  },
}
