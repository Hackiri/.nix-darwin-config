return {
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
    event = "InsertEnter",
    config = function()
      -- Define the language server path
      local cache_path = vim.fn.stdpath("cache")
      local ls_path = cache_path .. "/codeium/bin/1.20.9/language_server_macos_x64"

      -- Ensure directory exists
      local ls_dir = vim.fn.fnamemodify(ls_path, ":h")
      if vim.fn.isdirectory(ls_dir) == 0 then
        vim.fn.mkdir(ls_dir, "p")
      end

      -- Safe wrapper for plenary usage
      local function safe_require(module)
        local ok, result = pcall(require, module)
        if not ok then
          vim.notify("Failed to require " .. module .. ": " .. tostring(result), vim.log.levels.DEBUG)
          return nil
        end
        return result
      end

      -- Create a minimal implementation of plenary.async that doesn't actually require plenary
      -- This prevents errors when Windsurf tries to use plenary.async functionality
      local minimal_async = {
        -- Implement run function that executes the function directly instead of as a coroutine
        run = function(fn)
          return fn()
        end,
        
        -- Implement wrap function that returns a function that calls the callback with the results
        wrap = function(fn)
          return function(...)
            local args = {...}
            local cb = table.remove(args)
            local results = {fn(unpack(args))}
            cb(unpack(results))
          end
        end,
        
        -- Implement a minimal uv interface
        uv = setmetatable({}, {
          __index = function(_, key)
            -- Return a function that just calls the corresponding vim.loop function directly
            return function(...)
              local ok, result = pcall(vim.loop[key], ...)
              if not ok then
                return nil, result
              end
              return nil, result
            end
          end
        })
      }
      
      -- Make our minimal_async implementation available globally
      -- This will be used by Windsurf.nvim instead of loading plenary
      _G.plenary = { async = minimal_async }

      -- Setup codeium with plenary protection
      local codeium = safe_require("codeium")
      if not codeium then
        vim.notify("Failed to load Codeium", vim.log.levels.ERROR)
        return
      end

      codeium.setup({
        enable_cmp_source = false,
        enable_chat = true,
        language_server = {
          binary_path = ls_path,
          download_timeout = 300,
          start_timeout = 300,
        },
        tools = {
          language_server = ls_path,
        },
        -- Add debugging to help identify issues
        debug = true,
        -- Explicitly set the file path provider
        filetype = {
          -- Ensure all filetypes are enabled
          ['*'] = true,
        },
        -- Add completion configuration
        completion = {
          -- Increase timeout for completions
          timeout_ms = 5000,
          -- Add error handling for completions but only for critical errors
          on_error = function(err)
            -- Only show errors that aren't related to normal operation
            local error_str = tostring(err)
            if not error_str:match("\\.local/share/nvim/lazy") and 
               not error_str:match("failed to get completions") then
              vim.notify("Codeium completion error: " .. error_str, vim.log.levels.WARN)
            end
          end,
        },
      })

      -- Ensure the binary is executable after download
      vim.defer_fn(function()
        if vim.fn.filereadable(ls_path) == 1 then
          vim.fn.system({ "chmod", "+x", ls_path })
        end
      end, 2000)

      -- Register codeium with blink.cmp
      -- We already have codeium loaded from above, no need to require again
      
      -- Register with blink.cmp
      local blink = safe_require("blink.cmp")
      if blink then
        -- Ensure the codeium.blink module is available
        local codeium_blink = safe_require("codeium.blink")
        if not codeium_blink then
          vim.notify("codeium.blink module not found", vim.log.levels.ERROR)
        end
        
        blink.setup({
          sources = {
            {
              name = "codeium",
              priority = 50,
              group_index = 1,
            },
            {
              name = "nvim_lsp",
              priority = 100,
              group_index = 1,
            },
            {
              name = "buffer",
              priority = 30,
              group_index = 2,
            },
            {
              name = "path",
              priority = 40,
              group_index = 2,
            },
          },
        })
      end

      -- Add commands
      vim.api.nvim_create_user_command("CodeiumReload", function()
        -- Use our already loaded codeium module
        if codeium and codeium.reload then
          codeium.reload()
        else
          vim.notify("Failed to reload Codeium", vim.log.levels.ERROR)
        end
      end, {})

      vim.api.nvim_create_user_command("CodeiumToggle", function()
        vim.g.codeium_enabled = not vim.g.codeium_enabled
        print("Codeium " .. (vim.g.codeium_enabled and "enabled" or "disabled"))
      end, {})
      
      -- Add debug command to show current buffer info
      vim.api.nvim_create_user_command("CodeiumDebug", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        local filetype = vim.bo.filetype
        print("Buffer: " .. bufnr)
        print("Path: " .. filepath)
        print("Filetype: " .. filetype)
      end, {})
      
      -- Set up autocmd to ensure file path is set
      vim.api.nvim_create_autocmd({"BufEnter", "BufNewFile"}, {
        pattern = "*",
        callback = function()
          -- Ensure the buffer has a valid path
          local bufnr = vim.api.nvim_get_current_buf()
          local filepath = vim.api.nvim_buf_get_name(bufnr)
          if filepath == "" then
            -- For buffers without a path, we can set a temporary one
            -- This might help with the "path is empty" error
            local ft = vim.bo.filetype
            if ft ~= "" then
              -- Set a temporary path based on filetype
              vim.b.codeium_temp_path = "/tmp/codeium_temp_" .. ft .. "." .. ft
            end
          end
        end
      })
      
      -- Add diagnostics for auto-suggestions
      vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*",
        callback = function()
          -- Check if Codeium is enabled
          if not vim.g.codeium_enabled then
            return
          end
          
          -- Check current buffer validity
          local bufnr = vim.api.nvim_get_current_buf()
          local filepath = vim.api.nvim_buf_get_name(bufnr)
          local ft = vim.bo.filetype
          
          if filepath == "" and ft == "" then
            vim.notify("Codeium may not work in buffers without a path or filetype", vim.log.levels.INFO)
          end
        end
      })
      
      -- Add command to check Codeium status
      vim.api.nvim_create_user_command("CodeiumStatus", function()
        -- Check basic status
        local status = {
          enabled = vim.g.codeium_enabled or false,
        }
        
        print("Codeium Status:")
        print("- Enabled: " .. tostring(status.enabled))
        
        -- Check language server
        local ls_path = vim.fn.stdpath("cache") .. "/codeium/bin/1.20.9/language_server_macos_x64"
        print("- Language Server Path: " .. ls_path)
        print("- Language Server Exists: " .. tostring(vim.fn.filereadable(ls_path) == 1))
        print("- Language Server Executable: " .. tostring(vim.fn.executable(ls_path) == 1))
        
        -- Check current buffer
        local bufnr = vim.api.nvim_get_current_buf()
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        local ft = vim.bo.filetype
        print("- Current Buffer: " .. bufnr)
        print("- Current File Path: " .. filepath)
        print("- Current Filetype: " .. ft)
      end, {})
    end,
  },
}
