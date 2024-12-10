return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = function()
    local focused = true
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        focused = true
      end,
    })
    vim.api.nvim_create_autocmd("FocusLost", {
      callback = function()
        focused = false
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(event)
        vim.schedule(function()
          require("noice.text.markdown").keys(event.buf)
        end)
      end,
    })

    return {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          input = {}, -- Used by input()
        },
      },
      routes = {
        {
          filter = {
            cond = function()
              return not focused
            end,
          },
          view = "notify_send",
          opts = { stop = false },
        },
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
      commands = {
        all = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "single",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
    }
  end,
  config = function(_, opts)
    require("noice").setup(opts)
    vim.keymap.set("n", "<leader>nh", ":Noice history<CR>", { desc = "Noice History" })
    vim.keymap.set("n", "<leader>nl", ":Noice last<CR>", { desc = "Noice Last Message" })
  end,
}
