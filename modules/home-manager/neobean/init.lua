-- NeoBean Neovim Configuration

-- We're passing an env var from kitty, you can print it with:
-- :lua print(vim.env.NEOVIM_MODE)
-- Here we capture the environment variable to make it accessible to neovim
--
-- NOTE: To see all the files modified for skitty-notes just search for "neovim_mode"
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"
-- vim.g.bullets_enable_in_empty_buffers = 0

-- -- I have 2 style options "solid" and "transparent"
-- -- This style is defined in my zshrc file
-- -- :lua print(vim.env.MD_HEADING_BG)
vim.g.md_heading_bg = vim.env.MD_HEADING_BG

-- Set leader key before loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Python path is set in the nix configuration (extraLuaConfig)
-- This ensures pip and other required packages are available
-- Do not set it here to avoid conflicts with the nix configuration

-- Load lazy.nvim configuration first
require("config.lazy")

-- Load core configurations
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.colors")

require("config.highlights") -- Load custom highlights

-- Delay for `skitty` configuration
-- If I don't add this delay, I get the message
-- "Press ENTER or type command to continue"
if vim.g.neovim_mode == "skitty" then
  vim.wait(500, function()
    return false
  end) -- Wait for X miliseconds without doing anything
end
