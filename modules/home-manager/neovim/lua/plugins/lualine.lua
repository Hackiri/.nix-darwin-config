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
      normal = "",
      insert = "",
      visual = "",
      replace = "󰛔",
      command = "",
      terminal = "",

      -- Git
      git_branch = "",
      git_added = "",
      git_modified = "",
      git_removed = "",

      -- Diagnostics
      diagnostic_error = "",
      diagnostic_warn = "",
      diagnostic_info = "",
      diagnostic_hint = "",
      diagnostic_ok = "",

      -- Folding
      fold_lsp = "󱧊",
      fold_treesitter = "",
      fold_indent = "",
      fold_none = "󰝾",

      -- Misc
      line_number = " 󰏽",
      connected = "󰌘",
      disconnected = "󰌙",
      progress = "󰔟",
      lock = "",
      dots = "󰇘",
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
        cache.branch_color = (cache.branch == "live") and { fg = colors.red1, gui = "bold" } or nil
      end,
    })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      callback = function()
        if vim.bo.filetype ~= "sh" then
          cache.file_permissions = { perms = "", color = colors.gray1 }
          return
        end
        local file_path = vim.fn.expand("%:p")
        local permissions = file_path and vim.fn.getfperm(file_path) or "No File"
        local owner_permissions = permissions:sub(1, 3)
        cache.file_permissions = {
          perms = permissions,
          color = (owner_permissions == "rwx") and colors.green or colors.gray1,
        }
      end,
    })

    -- Utility functions
    local function hide_in_width()
      return vim.fn.winwidth(0) > 100
    end

    local function hide_in_small_window()
      return vim.fn.winwidth(0) > 70
    end

    local function get_venv_name()
      local venv = os.getenv("VIRTUAL_ENV")
      return venv and venv:match("([^/]+)$") or ""
    end

    local function should_show_permissions()
      return vim.bo.filetype == "sh" and vim.fn.expand("%:p") ~= ""
    end

    local function should_show_spell_status()
      return vim.bo.filetype == "markdown" and vim.wo.spell
    end

    local function get_spell_status()
      local lang_map = { en = "English", es = "Spanish" }
      return "Spell: " .. (lang_map[vim.bo.spelllang] or vim.bo.spelllang)
    end

    local function get_file_permissions()
      if vim.bo.filetype ~= "sh" then
        return "", colors.gray1
      end
      local file_path = vim.fn.expand("%:p")
      local permissions = file_path and vim.fn.getfperm(file_path) or "No File"
      local owner_permissions = permissions:sub(1, 3)
      return permissions, (owner_permissions == "rwx") and colors.green or colors.gray1
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
      color = function()
        return cache.branch_color
      end,
    }

    local location = {
      "location",
      padding = 0,
      fmt = function()
        return icons.line_number .. " %l:%c "
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
          statusline = { "dashboard", "alpha" },
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
        lualine_b = {
          branch,
          {
            get_venv_name,
            color = { fg = colors.cyan, gui = "bold" },
            cond = function()
              return get_venv_name() ~= ""
            end,
          },
          diff,
        },
        lualine_c = {
          filename,
          diagnostics,
        },
        lualine_x = {
          {
            get_spell_status,
            cond = should_show_spell_status,
            color = { fg = colors.purple, gui = "bold" },
          },
          {
            get_file_permissions,
            cond = should_show_permissions,
            color = function()
              local _, color = get_file_permissions()
              return { fg = color, gui = "bold" }
            end,
          },
          fold_method,
          "encoding",
          {
            "fileformat",
            symbols = {
              unix = "LF",
              dos = "CRLF",
              mac = "CR",
            },
          },
          "filetype",
        },
        lualine_y = {
          location,
          progress,
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
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
