return {
  "epwalsh/obsidian.nvim",
  event = { "BufReadPre " .. vim.fn.expand("~") .. "/Documents/Obsidian Vault/**.md" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("obsidian").setup({
      ui = {
        enable = false, -- Disable UI to prevent conflicts with render-markdown
      },
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/Obsidian Vault",
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      new_notes_location = "current_dir",
      wiki_link_func = function(opts)
        if opts.id == nil then
          return string.format("[[%s]]", opts.label)
        elseif opts.label ~= opts.id then
          return string.format("[[%s|%s]]", opts.id, opts.label)
        else
          return string.format("[[%s]]", opts.id)
        end
      end,
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },
    })

    -- Add keybindings for note operations under <leader>k prefix
    local obsidian = require("obsidian")
    vim.keymap.set("n", "<leader>kn", function()
      obsidian.new_note()
    end, { desc = "New Note" })
    vim.keymap.set("n", "<leader>ko", function()
      obsidian.open()
    end, { desc = "Open Note" })
    vim.keymap.set("n", "<leader>kb", function()
      obsidian.backlinks()
    end, { desc = "Show Backlinks" })
    vim.keymap.set("n", "<leader>kt", function()
      obsidian.today()
    end, { desc = "Open Today's Note" })
    vim.keymap.set("n", "<leader>ky", function()
      obsidian.yesterday()
    end, { desc = "Open Yesterday's Note" })
    vim.keymap.set("n", "<leader>kw", function()
      obsidian.tomorrow()
    end, { desc = "Open Tomorrow's Note" })
    vim.keymap.set("n", "<leader>ks", function()
      obsidian.search()
    end, { desc = "Search Notes" })
    vim.keymap.set("n", "<leader>kf", function()
      obsidian.follow_link()
    end, { desc = "Follow Link" })
  end,
}
