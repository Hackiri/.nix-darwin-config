-- Fuzzy Finder (files, lsp, etc)
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        scroll_strategy = "limit", -- Prevent cycling through results
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-c>"] = actions.close,
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<esc>"] = actions.close,
            -- Preview scrolling
            ["J"] = actions.preview_scrolling_down,
            ["K"] = actions.preview_scrolling_up,
            ["H"] = false,
            ["L"] = false,
          },
          n = {
            ["d"] = actions.delete_buffer,
            ["<esc>"] = actions.close,
            -- Preview scrolling
            ["J"] = actions.preview_scrolling_down,
            ["K"] = actions.preview_scrolling_up,
            ["H"] = false,
            ["L"] = false,
          },
        },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        path_display = {
          filename_first = {
            reverse_directories = true,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            initial_mode = "normal",
            sorting_strategy = "ascending",
            layout_strategy = "center",
            layout_config = {
              width = function(_, max_columns, _)
                return math.min(max_columns - 20, 120)
              end,
              height = function(_, _, max_lines)
                return math.min(max_lines - 10, 20)
              end,
            },
            border = true,
            borderchars = {
              prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
              results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
              preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            },
          }),
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
          find_command = { "rg", "--files", "--sortr=modified" },
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
          sort_mru = true,
          sort_lastused = true,
          show_all_buffers = true,
          ignore_current_buffer = true,
          path_display = { "smart" },
          layout_config = {
            width = 0.5,
            height = 0.4,
          },
        },
        live_grep = {
          theme = "dropdown",
          previewer = true,
        },
      },
      file_ignore_patterns = { "node_modules", ".git", ".venv" },
    })

    -- Enable telescope extensions
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    -- Add comprehensive keybindings under <leader>f prefix
    local function map(key, fn, desc)
      vim.keymap.set("n", key, fn, { desc = desc })
    end

    -- Files
    map("<leader>ff", builtin.find_files, "Find Files")
    map("<leader>fg", builtin.live_grep, "Find Text")
    map("<leader>fw", builtin.grep_string, "Find Current Word")
    map("<leader>fh", builtin.help_tags, "Find Help")
    map("<leader>fm", builtin.marks, "Find Marks")
    map("<leader>fo", builtin.oldfiles, "Find Recent Files")
    map("<leader>fb", builtin.buffers, "Find Buffers")

    -- Git
    map("<leader>fgf", builtin.git_files, "Find Git Files")
    map("<leader>fgc", builtin.git_commits, "Find Git Commits")
    map("<leader>fgb", builtin.git_branches, "Find Git Branches")
    map("<leader>fgs", builtin.git_status, "Find Git Status")

    -- LSP
    map("<leader>fd", builtin.diagnostics, "Find Diagnostics")
    map("<leader>fs", builtin.lsp_document_symbols, "Find Symbols")
    map("<leader>fr", builtin.lsp_references, "Find References")
    map("<leader>fi", builtin.lsp_implementations, "Find Implementations")

    -- Commands & Search
    map("<leader>fc", builtin.commands, "Find Commands")
    map("<leader>fk", builtin.keymaps, "Find Keymaps")
    map("<leader>f/", builtin.current_buffer_fuzzy_find, "Find in Current Buffer")
    map("<leader>f?", builtin.search_history, "Find Search History")
    map("<leader>f:", builtin.command_history, "Find Command History")

    -- Keymaps
    vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  end,
}
