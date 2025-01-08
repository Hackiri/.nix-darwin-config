return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
    event = "InsertEnter",
    config = function()
      require("codeium").setup({
        enable_cmp_source = false, -- Disable cmp source since we're using blink.cmp
        enable_chat = true,
        virtual_text = {
          enabled = true,
          manual = false,
          filetypes = {
            lua = true,
            python = true,
            javascript = true,
            typescript = true,
            rust = true,
            go = true,
            nix = true,
            markdown = true,
          },
          default_filetype_enabled = false,
          idle_delay = 75,
          virtual_text_priority = 65535,
          map_keys = true,
          accept_fallback = "<C-f>",
          key_bindings = {
            -- Use Alt-j/k for next/prev to avoid conflicts with copilot's Alt-[/]
            accept = "<M-;>", -- Changed from <M-l> to <M-;>
            accept_word = "<M-w>",
            accept_line = "<M-CR>",
            clear = "<M-c>",
            next = "<M-j>", -- Changed from <M-]> to <M-j>
            prev = "<M-k>", -- Changed from <M-[> to <M-k>
          },
        },
        filetypes = {
          ["*"] = true,
          TelescopePrompt = false,
          TelescopeResults = false,
          neo_tree = false,
          lazy = false,
          alpha = false,
          dashboard = false,
        },
      })

      -- Register codeium with blink.cmp by modifying its config
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        -- Add codeium to the sources configuration
        blink.setup({
          sources = {
            providers = {
              codeium = {
                name = "codeium",
                enabled = true,
                module = "codeium.cmp",
                kind = "Codeium",
                score_offset = 50, -- Lower priority than LSP but higher than buffer
              },
            },
            default = { "lsp", "path", "snippets", "buffer", "luasnip", "codeium" },
          },
        })
      end

      -- Add commands for quick access
      vim.api.nvim_create_user_command("CodeiumToggle", function()
        vim.g.codeium_enabled = not vim.g.codeium_enabled
        print("Codeium " .. (vim.g.codeium_enabled and "enabled" or "disabled"))
      end, {})

      -- Add keymaps for quick access
      vim.keymap.set("n", "<leader>ce", "<cmd>CodeiumEnable<cr>", { desc = "Enable Codeium" })
      vim.keymap.set("n", "<leader>cd", "<cmd>CodeiumDisable<cr>", { desc = "Disable Codeium" })
      vim.keymap.set("n", "<leader>ct", "<cmd>CodeiumToggle<cr>", { desc = "Toggle Codeium" })
      vim.keymap.set("n", "<leader>cc", "<cmd>Codeium Chat<cr>", { desc = "Codeium Chat" })
    end,
  },
}
