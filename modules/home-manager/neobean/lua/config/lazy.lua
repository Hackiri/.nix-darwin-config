-- NeoBean lazy.nvim configuration

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

-- Set the python3_host_prog variable
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/neovim/bin/python")

-- Safe require function to handle missing modules
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.notify("Could not load " .. module, vim.log.levels.WARN)
    return nil
  end
  return result
end

-- Ensure dap is available globally to prevent nil errors
if not _G.dap then
  _G.dap = {
    setup = function() end,
    adapters = {},
    configurations = {},
    listeners = {
      after = { event_initialized = {} },
      before = { event_terminated = {}, event_exited = {} },
    },
  }
end

-- Setup minimal plenary.async implementation for Codeium
-- This prevents errors when plenary is loaded during completions
if not _G.plenary then
  _G.plenary = {}
end

if not _G.plenary.async then
  _G.plenary.async = {
    run = function(fn, callback)
      local co = coroutine.create(fn)
      local function step(...)
        local ok, result = coroutine.resume(co, ...)
        if not ok then
          error(result)
        end
        if coroutine.status(co) == "dead" then
          if callback then
            callback(result)
          end
          return
        end
        result(step)
      end
      step()
    end,
    void = function(fn)
      return function(...)
        local args = { ... }
        return function(callback)
          local co = coroutine.create(fn)
          local ok, result = coroutine.resume(co, unpack(args))
          if not ok then
            error(result)
          end
          if callback then
            callback(result)
          end
        end
      end
    end,
  }
end

-- Setup lazy.nvim with plugins
require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import any extra modules here
    -- I do this to keep consistency and install the same plugins in all my
    -- machines, if you don't want that, comment them here and then manually
    -- enable them on each machine under :LazyExtras
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.editor.harpoon2" },
    { import = "lazyvim.plugins.extras.editor.mini-diff" },
    { import = "lazyvim.plugins.extras.editor.snacks_picker" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.terraform" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.helm" },
    -- { import = "lazyvim.plugins.extras.ai.copilot" },
    -- { import = "lazyvim.plugins.extras.ai.copilot-chat" },
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    -- { import = "lazyvim.plugins.extras.lang.php" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
    { import = "plugins.colorschemes" },

    -- Ensure plenary.nvim is available for plugins that need it
    {
      "nvim-lua/plenary.nvim",
      lazy = true,
      module = true,
      init = function()
        -- Create a minimal plenary.path implementation for plugins that need it
        if not _G.plenary then
          _G.plenary = {}
        end
        if not _G.plenary.path then
          _G.plenary.path = {
            exists = function(path)
              return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
            end,
            new = function(path)
              local obj = { filename = path }
              function obj:exists()
                return vim.fn.filereadable(self.filename) == 1 or vim.fn.isdirectory(self.filename) == 1
              end
              function obj:absolute()
                return vim.fn.fnamemodify(self.filename, ":p")
              end
              function obj:make_relative(cwd)
                return vim.fn.fnamemodify(self.filename, ":.")
              end
              function obj:normalize()
                local path = vim.fn.fnamemodify(self.filename, ":p")
                -- Replace backslashes with forward slashes
                path = path:gsub("\\", "/")
                -- Replace multiple slashes with a single slash
                path = path:gsub("/+", "/")
                -- Remove trailing slash
                path = path:gsub("/$", "")
                -- Replace ~ with home directory
                path = path:gsub("^~", vim.fn.expand("~"))
                return path
              end
              return obj
            end,
          }
        end
      end,
    },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
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
  },
})
