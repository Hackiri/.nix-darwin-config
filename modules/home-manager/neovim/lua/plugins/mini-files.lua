return {
  "echasnovski/mini.files",
  version = false,
  event = "VeryLazy",
  keys = {
    {
      "<leader>mf",
      function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
        if vim.fn.filereadable(buf_name) == 1 then
          require("mini.files").open(buf_name, true)
        elseif vim.fn.isdirectory(dir_name) == 1 then
          require("mini.files").open(dir_name, true)
        else
          require("mini.files").open(vim.uv.cwd(), true)
        end
      end,
      desc = "Mini Files (Current File)",
    },
    {
      "<leader>md",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Mini Files (Directory)",
    },
  },
  opts = {
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 50,
    },
    options = {
      use_as_default_explorer = false,
      permanent_delete = false,
    },
    mappings = {
      close = "<esc>",
      go_in = "l",
      go_in_plus = "<CR>",
      go_out = "H",
      go_out_plus = "h",
      reset = "<BS>",
      reveal_cwd = ".",
      show_help = "g?",
      synchronize = "s",
      trim_left = "<",
      trim_right = ">",
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)

    -- Add highlighting for git status
    local show_git = function()
      local mf = require("mini.files")
      local git_status = require("mini.files").get_fs_entry().path
      vim.system({ "git", "status", "--porcelain", git_status }, {}, function(p)
        if p.code ~= 0 then
          return
        end
        for line in vim.gsplit(p.stdout or "", "\n", { plain = true }) do
          if line ~= "" then
            local status = line:sub(1, 2)
            local file = line:sub(4)
            local fs_entry = mf.get_fs_entry()
            if fs_entry and fs_entry.path:match(vim.pesc(file) .. "$") then
              local highlight = ({
                ["??"] = "GitSignsUntracked",
                ["!!"] = "GitSignsUntracked",
                ["AA"] = "GitSignsUntracked",
                ["DD"] = "GitSignsUntracked",
                ["AU"] = "GitSignsUntracked",
                ["UD"] = "GitSignsUntracked",
                ["UA"] = "GitSignsUntracked",
                ["DU"] = "GitSignsUntracked",
                ["MM"] = "GitSignsChange",
                [" M"] = "GitSignsChange",
                ["M "] = "GitSignsChange",
                ["AM"] = "GitSignsChange",
                ["MD"] = "GitSignsChange",
                ["A "] = "GitSignsAdd",
                [" A"] = "GitSignsAdd",
                ["D "] = "GitSignsDelete",
                [" D"] = "GitSignsDelete",
                ["R "] = "GitSignsChange",
                [" R"] = "GitSignsChange",
                ["C "] = "GitSignsChange",
                [" C"] = "GitSignsChange",
                ["T "] = "GitSignsChange",
                [" T"] = "GitSignsChange",
                ["UU"] = "GitSignsChange",
              })[status]
              if highlight then
                vim.api.nvim_buf_add_highlight(0, -1, highlight, fs_entry.line - 1, 0, -1)
              end
            end
          end
        end
      end)
    end

    -- Update git status when opening files view
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function()
        vim.schedule(show_git)
      end,
    })

    -- Add file preview
    local files = require("mini.files")
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowUpdate",
      callback = function(args)
        local state = files.get_explorer_state()
        if not state then
          return
        end

        local win_id = state.target_window
        if not win_id or not vim.api.nvim_win_is_valid(win_id) then
          return
        end

        local cur_entry = files.get_fs_entry()
        if not (cur_entry and cur_entry.fs_type == "file") then
          return
        end

        -- Get preview window if it exists
        local preview_buf, preview_win
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            local win_buf = vim.api.nvim_win_get_buf(win)
            local win_config = vim.api.nvim_win_get_config(win)
            if win_config.relative ~= "" then -- Is floating window
              preview_buf = win_buf
              preview_win = win
              break
            end
          end
        end

        if preview_buf and preview_win then
          -- Load file into preview buffer
          local path = cur_entry.path
          local buf_id = vim.fn.bufadd(path)
          vim.fn.bufload(buf_id)

          -- Set preview buffer
          pcall(vim.api.nvim_win_set_buf, preview_win, buf_id)

          -- Try to maintain cursor position safely
          pcall(function()
            local cursor = vim.api.nvim_win_get_cursor(win_id)
            local line_count = vim.api.nvim_buf_line_count(buf_id)
            if cursor[1] > line_count then
              cursor[1] = line_count
            end
            vim.api.nvim_win_set_cursor(preview_win, cursor)
          end)
        end
      end,
    })
  end,
}
