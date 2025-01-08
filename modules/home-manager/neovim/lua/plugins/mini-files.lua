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
    {
      "<leader>mh",
      function()
        require("mini.files").open(vim.fn.expand("~"), true)
      end,
      desc = "Mini Files (Home)",
    },
    {
      "<leader>mc",
      function()
        require("mini.files").open(vim.fn.stdpath("config"), true)
      end,
      desc = "Mini Files (Config)",
    },
    {
      "<leader>mp",
      function()
        local mf = require("mini.files")
        if not mf.close() then
          mf.open(mf.get_fs_entry().path)
        end
      end,
      desc = "Mini Files (Toggle Preview)",
    },
  },
  opts = {
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 80, -- Increased from 50 to 80 for better preview
    },
    options = {
      use_as_default_explorer = true, -- Set to true to use as default explorer
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
      -- Additional file operation mappings
      ["<space>yy"] = function()
        local fs_entry = require("mini.files").get_fs_entry()
        if fs_entry then
          vim.fn.setreg("+", fs_entry.path)
          vim.notify("Copied path to clipboard: " .. fs_entry.path)
        end
      end,
      ["<space>p"] = function()
        local clipboard = vim.fn.getreg("+")
        if clipboard ~= "" then
          local target = require("mini.files").get_fs_entry().path
          vim.fn.system({ "cp", "-r", clipboard, target })
          require("mini.files").refresh()
        end
      end,
      ["<M-c>"] = function()
        local fs_entry = require("mini.files").get_fs_entry()
        if fs_entry then
          vim.fn.setreg("+", fs_entry.path)
          vim.notify("Copied full path: " .. fs_entry.path)
        end
      end,
      ["<space>i"] = function()
        local fs_entry = require("mini.files").get_fs_entry()
        if fs_entry and vim.fn.executable("viu") == 1 then
          vim.fn.system({ "viu", fs_entry.path })
        end
      end,
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)

    -- Add highlighting for git status
    local function update_git_status()
      local mf = require("mini.files")
      local state = mf.get_explorer_state()
      if not state then
        return
      end

      local buf = vim.api.nvim_get_current_buf()
      if not (buf and type(buf) == "number" and vim.api.nvim_buf_is_valid(buf)) then
        return
      end

      local current_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p:h")
      local cmd = string.format("git -C %s status --porcelain", vim.fn.shellescape(current_path))

      local output = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        return
      end

      local ns_id = vim.api.nvim_create_namespace("mini_files_git")
      vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

      for _, line in ipairs(vim.split(output, "\n", { trimempty = true })) do
        local status = line:sub(1, 2)
        local file = line:sub(4)
        local highlight = ({
          ["??"] = "GitSignsUntracked",
          ["!!"] = "GitSignsUntracked",
          ["AA"] = "GitSignsUntracked",
          ["DD"] = "GitSignsUntracked",
          ["AU"] = "GitSignsUntracked",
          ["UD"] = "GitSignsUntracked",
          ["UA"] = "GitSignsUntracked",
          ["M "] = "GitSignsChange",
          [" M"] = "GitSignsChange",
          ["MM"] = "GitSignsChange",
          ["R "] = "GitSignsChange",
          ["A "] = "GitSignsAdd",
          ["D "] = "GitSignsDelete",
        })[status]

        if highlight then
          local filename = vim.fn.fnamemodify(file, ":t")
          local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          for i, content in ipairs(buf_lines) do
            if content:match(vim.pesc(filename) .. "$") then
              pcall(vim.api.nvim_buf_add_highlight, buf, ns_id, highlight, i - 1, 0, -1)
              break
            end
          end
        end
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function()
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
          callback = function()
            vim.schedule(function()
              pcall(update_git_status)
            end)
          end,
          group = vim.api.nvim_create_augroup("MiniFilesGitStatus", { clear = true }),
        })
      end,
    })
  end,
}
