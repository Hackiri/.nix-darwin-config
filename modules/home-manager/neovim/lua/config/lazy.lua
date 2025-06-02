-- lua/config/lazy.lua

-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim
require("lazy").setup({
  defaults = {
    lazy = false,
    version = false,
  },
  dev = {
    path = vim.fn.stdpath("data") .. "/lazy",
    patterns = { "." },
    fallback = true,
  },
  spec = {
    -- Import LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Explicitly enable specific plugins
    -- { "zbirenbaum/copilot.lua", enabled = true },
    -- { "github/copilot.vim", enabled = true }, -- Remove this line
    -- { "CopilotC-Nvim/CopilotChat.nvim", enabled = true },
    { "github/copilot.vim", enabled = true },
    -- Other plugin configurations
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
    { "williamboman/mason-lspconfig.nvim", enabled = true },
    { "williamboman/mason.nvim", enabled = true },
    { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
    -- Import user plugins
    { import = "plugins" },
  },
  install = { colorscheme = {} },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        -- "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
