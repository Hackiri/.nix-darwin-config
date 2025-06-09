-- Debug Adapter Protocol configuration
return {
  -- DAP client for neovim
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      { "rcarriga/nvim-dap-ui" },
      -- Virtual text for DAP
      { "theHamsta/nvim-dap-virtual-text" },
      -- Mason integration
      { "jay-babu/mason-nvim-dap.nvim" },
      -- Python adapter
      { "mfussenegger/nvim-dap-python" },
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      -- Use _G.dap if it exists, otherwise require it
      local dap = _G.dap or require("dap")
      
      -- Safely require dapui
      local ok, dapui = pcall(require, "dapui")
      if not ok then
        vim.notify("Could not load dapui", vim.log.levels.WARN)
        return
      end
      
      -- Set up UI
      dapui.setup()
      
      -- Set up virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
      })
      
      -- Automatically open/close the UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      
      -- Python configuration
      -- Use the Python path from the Neovim virtual environment
      local python_path = vim.fn.expand("~/.venvs/neovim/bin/python")
      
      -- Safely set up Python debugging
      local dap_python_ok, dap_python = pcall(require, "dap-python")
      if dap_python_ok then
        dap_python.setup(python_path)
        
        -- Ensure debugpy is installed in the virtual environment
        vim.fn.system(python_path .. " -m pip install debugpy")
      end
      
      -- JavaScript/TypeScript debugging with vscode-js-debug
      -- This uses mason to install the adapter
      local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
      if mason_dap_ok then
        mason_dap.setup({
          ensure_installed = { "js-debug-adapter" },
          automatic_installation = true,
          handlers = {
            function(config)
              -- All sources with no handler get passed here
              -- Keep original functionality
              mason_dap.default_setup(config)
            end,
          },
        })
      end
      
      -- Configure JavaScript/TypeScript debugging
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }
      
      dap.configurations.typescript = dap.configurations.javascript
    end,
  },
  
  -- UI for DAP
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
  },
  
  -- Mason DAP integration
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
      ensure_installed = {
        "python", -- Python debugging
      },
    },
  },
}
