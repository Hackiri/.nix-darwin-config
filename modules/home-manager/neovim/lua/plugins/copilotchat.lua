-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    enabled = true, -- Explicitly enable the plugin
    priority = 1000, -- High priority to load after copilot
    dependencies = {
      "zbirenbaum/copilot.lua", -- Make sure copilot is loaded first
      "nvim-lua/plenary.nvim",
    },
    opts = function(_, opts)
      -- Initialize options
      opts = opts or {}

      -- Set default model if not set in options.lua
      opts.model = _G.COPILOT_MODEL or "gpt-4"

      -- Format username
      local user = (vim.env.USER or "User"):gsub("^%l", string.upper)
      opts.question_header = string.format(" %s (%s) ", user, opts.model)

      -- Configure mappings
      opts.mappings = {
        close = {
          normal = "<Esc>",
          insert = "<C-c>",
        },
        reset = "<C-l>",
        submit_prompt = "<CR>",
        accept_diff = "<C-y>",
        show_diff = "<C-s>",
      }

      return opts
    end,
    -- Add keymaps for quick access
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "CopilotChat - Open" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix code" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Reset chat" },
    },
  },
}
