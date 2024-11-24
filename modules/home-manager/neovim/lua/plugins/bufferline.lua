return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'moll/vim-bbye',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Icons
    local icons = {
      buffer = {
        close = '✗',
        modified = '●',
        locked = '',
        pinned = '󰐃',
        duplicate = '󰈢',
        separator = '│',
        pick = '󰛖',
      },
      diagnostics = {
        error = ' ',
        warning = ' ',
        info = ' ',
        hint = ' ',
      },
      git = {
        added = ' ',
        modified = ' ',
        removed = ' ',
      },
      filetype = {
        default = '',
        terminal = '',
      },
    }

    -- Colors
    local colors = {
      fg = '#abb2bf',
      bg = '#282c34',
      gray = '#3e4452',
      blue = '#61afef',
      green = '#98c379',
      purple = '#c678dd',
      red = '#e06c75',
      yellow = '#e5c07b',
      cyan = '#56b6c2',
      orange = '#d19a66',
    }

    -- Diagnostic highlights
    local diagnostics_highlights = {
      error = {
        fg = colors.red,
        bg = colors.bg,
      },
      warning = {
        fg = colors.yellow,
        bg = colors.bg,
      },
      info = {
        fg = colors.blue,
        bg = colors.bg,
      },
      hint = {
        fg = colors.cyan,
        bg = colors.bg,
      },
    }

    require('bufferline').setup {
      options = {
        -- Basic settings
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        
        -- Commands
        close_command = 'Bdelete! %d',
        right_mouse_command = 'Bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        
        -- Icons
        buffer_close_icon = icons.buffer.close,
        modified_icon = icons.buffer.modified,
        close_icon = icons.buffer.close,
        left_trunc_marker = '',
        right_trunc_marker = '',
        
        -- Appearance
        separator_style = { icons.buffer.separator, icons.buffer.separator },
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        
        -- Naming
        name_formatter = function(buf)
          return ' ' .. buf.name
        end,
        
        -- Sizing
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        padding = 1,
        
        -- Features
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = diagnostics_highlights[level] and icons.diagnostics[level] or ''
          return ' ' .. icon .. count
        end,
        
        -- Icons and colors
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        
        -- Behavior
        persist_buffer_sort = true,
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        sort_by = 'insert_at_end',
        
        -- Custom filtering
        custom_filter = function(buf_number, buf_numbers)
          -- filter out filetypes you don't want to see
          local exclude_ft = { 'qf', 'fugitive', 'git' }
          local cur_ft = vim.bo[buf_number].filetype
          local should_filter = vim.tbl_contains(exclude_ft, cur_ft)
          
          if should_filter then
            return false
          end
          
          return true
        end,
        
        -- Groups
        groups = {
          options = {
            toggle_hidden_on_enter = true
          },
          items = {
            {
              name = "Tests",
              highlight = { fg = colors.green },
              icon = icons.filetype.default,
              matcher = function(buf)
                return buf.name:match('_test') or buf.name:match('test_')
              end,
            },
            {
              name = "Docs",
              highlight = { fg = colors.yellow },
              matcher = function(buf)
                local ft = vim.bo[buf.id].filetype
                return ft == "markdown" or ft == "txt" or ft == "help"
              end,
            },
          }
        },
      },

      highlights = {
        -- Buffer highlights
        buffer_selected = {
          fg = colors.fg,
          bg = colors.bg,
          bold = true,
          italic = false,
        },
        buffer_visible = {
          fg = colors.gray,
          bg = colors.bg,
        },
        
        -- Close button
        close_button = {
          fg = colors.gray,
          bg = colors.bg,
        },
        close_button_selected = {
          fg = colors.red,
          bg = colors.bg,
        },
        
        -- Modified
        modified = {
          fg = colors.yellow,
          bg = colors.bg,
        },
        modified_selected = {
          fg = colors.green,
          bg = colors.bg,
        },
        
        -- Separators
        separator = {
          fg = colors.gray,
          bg = colors.bg,
        },
        separator_selected = {
          fg = colors.gray,
          bg = colors.bg,
        },
        
        -- Indicators
        indicator_selected = {
          fg = colors.blue,
          bg = colors.bg,
        },
        
        -- Diagnostics
        error = diagnostics_highlights.error,
        warning = diagnostics_highlights.warning,
        info = diagnostics_highlights.info,
        hint = diagnostics_highlights.hint,
        
        -- Tabs
        tab = {
          fg = colors.gray,
          bg = colors.bg,
        },
        tab_selected = {
          fg = colors.fg,
          bg = colors.bg,
          bold = true,
        },
      },
    }

    -- Keymaps
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Buffer navigation
    map('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', opts)
    map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', opts)
    
    -- Buffer operations
    map('n', '<leader>bc', '<cmd>Bdelete<cr>', { desc = 'Close buffer' })
    map('n', '<leader>bC', '<cmd>Bdelete!<cr>', { desc = 'Force close buffer' })
    map('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>', { desc = 'Toggle pin' })
    map('n', '<leader>bP', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })
    
    -- Quick buffer switching
    for i = 1, 9 do
      map('n', string.format('<leader>%d', i),
        string.format('<cmd>BufferLineGoToBuffer %d<cr>', i),
        { desc = 'Go to buffer ' .. i })
    end
    
    -- Buffer sorting
    map('n', '<leader>bl', '<cmd>BufferLineSortByDirectory<cr>', { desc = 'Sort by directory' })
    map('n', '<leader>bL', '<cmd>BufferLineSortByExtension<cr>', { desc = 'Sort by extension' })
  end,
}
