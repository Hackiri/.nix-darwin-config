-- snippets.lua
-- Configuration for various Neovim behaviors and appearance

-----------------------------------------------------------
-- LSP and Treesitter Integration
-----------------------------------------------------------
-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.highlight.priorities.semantic_tokens = 95

-----------------------------------------------------------
-- Diagnostic Configuration
-----------------------------------------------------------
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    -- Add a custom format function to show error codes
    format = function(diagnostic)
      local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
      return string.format("%s %s", code, diagnostic.message)
    end,
  },
  underline = false,
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
})

-----------------------------------------------------------
-- Autocommands
-----------------------------------------------------------
-- Make diagnostic background transparent
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("highlight DiagnosticVirtualText guibg=NONE")
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-----------------------------------------------------------
-- Terminal Integration (Alacritty)
-----------------------------------------------------------
-- Set alacritty terminal padding
local function setup_alacritty_padding()
  -- Check if we're in Alacritty terminal
  if vim.env.TERM == "alacritty" then
    local alacritty_group = vim.api.nvim_create_augroup("AlacrittyPadding", { clear = true })

    -- Reset padding on exit
    vim.api.nvim_create_autocmd("VimLeave", {
      group = alacritty_group,
      callback = function()
        vim.fn.system("alacritty @ set-spacing padding=default margin=default")
      end,
    })

    -- Set padding on enter
    vim.api.nvim_create_autocmd("VimEnter", {
      group = alacritty_group,
      callback = function()
        vim.fn.system("alacritty @ set-spacing padding=0 margin=0 3 0 3")
      end,
    })
  end
end

-- Initialize alacritty padding settings
setup_alacritty_padding()

-----------------------------------------------------------
-- Additional Utilities
-----------------------------------------------------------
-- Add any additional utility functions or configurations here
