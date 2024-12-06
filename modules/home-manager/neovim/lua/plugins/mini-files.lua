return {
  "echasnovski/mini.files",
  version = false,
  event = "VeryLazy",
  opts = {
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 50,
    },
    options = {
      -- Whether to use for editing directories
      use_as_default_explorer = true,
      -- If false, files are moved to trash: ~/.local/share/nvim/mini.files/trash
      permanent_delete = false,
    },
    -- Customize mappings for better usability
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
  keys = {
    {
      "<leader>m",
      function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
        if vim.fn.filereadable(buf_name) == 1 then
          -- Pass the full file path to highlight the file
          require("mini.files").open(buf_name, true)
        elseif vim.fn.isdirectory(dir_name) == 1 then
          -- If the directory exists but the file doesn't, open the directory
          require("mini.files").open(dir_name, true)
        else
          -- If neither exists, fallback to the current working directory
          require("mini.files").open(vim.uv.cwd(), true)
        end
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>M",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
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
        local win_id = args.data.win_id
        if not win_id then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(win_id)
        local current_item = files.get_fs_entry()
        if not current_item or current_item.fs_type ~= "file" then
          return
        end
        local buf_id = vim.fn.bufadd(current_item.path)
        vim.fn.bufload(buf_id)
        local preview_win = files.get_window_number("preview")
        if preview_win then
          vim.api.nvim_win_set_buf(preview_win, buf_id)
        end
        vim.api.nvim_win_set_cursor(win_id, cursor)
      end,
    })
  end,
}
