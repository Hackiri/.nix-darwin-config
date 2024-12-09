return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 2, require("lazyvim.util").lualine.cmp_source("codeium"))
  end,
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    -- Color palette
    local colors = {
      bg = "#1a1b26",
      fg = "#c0caf5",
      yellow = "#e0af68",
      cyan = "#7dcfff",
      darkblue = "#7aa2f7",
      green = "#9ece6a",
      orange = "#ff9e64",
      violet = "#bb9af7",
      magenta = "#bb9af7",
      blue = "#7aa2f7",
      red = "#f7768e",
      git = { add = "#9ece6a", change = "#e0af68", delete = "#f7768e" },
      error = "#f7768e",
      warn = "#e0af68",
      info = "#7aa2f7",
      hint = "#1abc9c",
    }

    -- Mode colors
    local mode_colors = {
      normal = colors.blue,
      insert = colors.green,
      visual = colors.magenta,
      replace = colors.red,
      command = colors.yellow,
      terminal = colors.cyan,
      inactive = colors.fg,
    }

    -- Icons
    local icons = {
      -- Mode
      normal = "󰆧 ",
      insert = " ",
      visual = "󰈈 ",
      replace = "󰛔 ",
      command = "󰘳 ",
      terminal = " ",

      -- Git
      git_branch = " ",
      git_added = " ",
      git_modified = " ",
      git_removed = " ",

      -- Diagnostics
      diagnostic_error = "",
      diagnostic_warn = "",
      diagnostic_info = "",
      diagnostic_hint = "󰌶",
      diagnostic_ok = "󰩐",

      -- Misc
      line_number = " 󰏽",
      connected = "󰌘",
      disconnected = "󰌙",
      progress = "󰔟",
      lock = "",
      dots = "󰇘",
      clock = "",
    }

    -- Cache system for improved performance
    local cache = {
      branch = "",
      branch_color = nil,
      file_permissions = { perms = "", color = colors.green },
    }

    -- Set up autocmds for cache updates
    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
      callback = function()
        -- Update git branch
        cache.branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
        cache.branch_color = (cache.branch == "live") and { fg = colors.red, gui = "bold" } or nil
      end,
    })

    -- Component configurations
    local mode = {
      "mode",
      fmt = function(str)
        return icons[str:lower()] or str
      end,
      color = function()
        return { fg = mode_colors[vim.fn.mode()] or colors.fg }
      end,
    }

    local filename = {
      "filename",
      path = 1,
      symbols = {
        modified = icons.dots,
        readonly = icons.lock,
        unnamed = "[No Name]",
      },
    }

    local filetype = {
      "filetype",
      icons_enabled = true,
    }

    local branch = {
      "branch",
      icon = icons.git_branch,
      color = function()
        return cache.branch_color
      end,
    }

    local diff = {
      "diff",
      symbols = {
        added = icons.git_added,
        modified = icons.git_modified,
        removed = icons.git_removed,
      },
      source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end,
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        error = icons.diagnostic_error,
        warn = icons.diagnostic_warn,
        info = icons.diagnostic_info,
        hint = icons.diagnostic_hint,
        ok = icons.diagnostic_ok,
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
    }

    local progress = {
      "progress",
      fmt = function()
        return icons.progress
      end,
    }

    -- Configure lualine
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar = { "dashboard", "alpha", "starter" },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch, diff },
        lualine_c = { filename },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = colors.orange },
          },
          diagnostics,
          filetype,
        },
        lualine_y = { "location" },
        lualine_z = { progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "neo-tree", "lazy" },
    })
  end,
}
