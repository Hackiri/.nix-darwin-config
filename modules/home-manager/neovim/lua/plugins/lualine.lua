return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    -- Color palette
    local colors = {
      -- Base colors
      blue = "#61afef",
      green = "#98c379",
      purple = "#c678dd",
      cyan = "#56b6c2",
      red1 = "#e06c75",
      red2 = "#be5046",
      yellow = "#e5c07b",
      orange = "#d19a66",

      -- Monochrome
      fg = "#abb2bf",
      bg = "#282c34",
      gray1 = "#828997",
      gray2 = "#2c323c",
      gray3 = "#3e4452",

      -- Git colors
      git_add = "#98c379",
      git_change = "#61afef",
      git_delete = "#e06c75",

      -- Diagnostic colors
      error = "#e06c75",
      warn = "#e5c07b",
      info = "#61afef",
      hint = "#56b6c2",
    }

    -- Icons
    local icons = {
      -- Mode
      normal = "",
      insert = "",
      visual = "",
      replace = "",
      command = "",
      terminal = "",

      -- Git
      git_branch = "",
      git_added = "",
      git_modified = "",
      git_removed = "",

      -- Diagnostics
      diagnostic_error = "",
      diagnostic_warn = "",
      diagnostic_info = "",
      diagnostic_hint = "",

      -- Folding
      fold_lsp = "󰆘",
      fold_treesitter = "󰙅",
      fold_indent = "",
      fold_none = "",

      -- Misc
      line_number = "",
      connected = "󰌘",
      disconnected = "󰌙",
      progress = "󰔟",
      lock = "",
      dots = "󰇘",
    }

    -- Utility functions
    local function hide_in_width()
      return vim.fn.winwidth(0) > 100
    end

    local function hide_in_small_window()
      return vim.fn.winwidth(0) > 70
    end

    -- Component configurations
    local mode = {
      "mode",
      fmt = function(str)
        local mode_icons = {
          NORMAL = icons.normal,
          INSERT = icons.insert,
          VISUAL = icons.visual,
          ["V-LINE"] = icons.visual,
          ["V-BLOCK"] = icons.visual,
          REPLACE = icons.replace,
          COMMAND = icons.command,
          TERMINAL = icons.terminal,
        }
        return " " .. (mode_icons[str] or "") .. " " .. str
      end,
    }

    local filename = {
      "filename",
      file_status = true,
      path = 1,
      shorting_target = 40,
      symbols = {
        modified = "[+]",
        readonly = "",
        unnamed = "[No Name]",
        newfile = "[New]",
      },
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        error = icons.diagnostic_error .. " ",
        warn = icons.diagnostic_warn .. " ",
        info = icons.diagnostic_info .. " ",
        hint = icons.diagnostic_hint .. " ",
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      diagnostics_color = {
        error = { fg = colors.error },
        warn = { fg = colors.warn },
        info = { fg = colors.info },
        hint = { fg = colors.hint },
      },
    }

    local diff = {
      "diff",
      colored = true,
      symbols = {
        added = icons.git_added .. " ",
        modified = icons.git_modified .. " ",
        removed = icons.git_removed .. " ",
      },
      diff_color = {
        added = { fg = colors.git_add },
        modified = { fg = colors.git_change },
        removed = { fg = colors.git_delete },
      },
      cond = hide_in_width,
    }

    local branch = {
      "branch",
      icons_enabled = true,
      icon = icons.git_branch,
      colored = true,
      color = { fg = colors.purple, gui = "bold" },
    }

    local location = {
      "location",
      padding = 0,
      fmt = function()
        return icons.line_number .. " %l:%c"
      end,
    }

    local progress = {
      "progress",
      fmt = function(str)
        return icons.progress .. " " .. str
      end,
    }

    local fold_method = {
      function()
        local ok, folding = pcall(require, "config.folding")
        if not ok then
          return ""
        end
        local method = folding.get_fold_method()
        local method_icons = {
          lsp = icons.fold_lsp,
          treesitter = icons.fold_treesitter,
          indent = icons.fold_indent,
          none = icons.fold_none,
        }
        return method_icons[method] .. " " .. method:upper()
      end,
      cond = hide_in_small_window,
      color = { fg = colors.purple },
    }

    -- Setup
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
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
        lualine_b = { branch },
        lualine_c = {
          filename,
          {
            function()
              return "%="
            end,
          },
          diagnostics,
        },
        lualine_x = {
          diff,
          fold_method,
          {
            "filetype",
            colored = true,
            icon_only = false,
            icon = { align = "right" },
            cond = hide_in_small_window,
          },
          {
            "encoding",
            fmt = string.upper,
            cond = hide_in_width,
          },
          {
            "fileformat",
            icons_enabled = true,
            symbols = {
              unix = "LF",
              dos = "CRLF",
              mac = "CR",
            },
            cond = hide_in_width,
          },
        },
        lualine_y = { location },
        lualine_z = { progress },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      tabline = {},

      extensions = {
        "fugitive",
        "neo-tree",
        "quickfix",
        "toggleterm",
      },
    })
  end,
}
