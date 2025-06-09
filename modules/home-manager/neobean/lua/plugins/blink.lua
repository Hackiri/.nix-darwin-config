-- Codeium integration with blink.cmp
-- This file provides a minimal implementation to prevent plenary.nvim loading errors

-- Safe require function to handle missing modules
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    return nil
  end
  return result
end

-- Ensure plenary.async is available globally
if not _G.plenary then
  _G.plenary = {}
end

if not _G.plenary.async then
  _G.plenary.async = {
    run = function(fn, callback)
      local co = coroutine.create(fn)
      local function step(...)
        local ok, result = coroutine.resume(co, ...)
        if not ok then
          error(result)
        end
        if coroutine.status(co) == "dead" then
          if callback then
            callback(result)
          end
          return
        end
        result(step)
      end
      step()
    end,
    void = function(fn)
      return function(...)
        local args = {...}
        return function(callback)
          local co = coroutine.create(fn)
          local ok, result = coroutine.resume(co, unpack(args))
          if not ok then
            error(result)
          end
          if callback then
            callback(result)
          end
        end
      end
    end
  }
end

-- Get Codeium module safely
local codeium = safe_require("codeium")
if not codeium then
  return {
    get_completions = function()
      return {}
    end
  }
end

-- Minimal blink.cmp integration
local M = {}

-- Get completions from Codeium
M.get_completions = function(params, callback)
  -- Safely get completions from Codeium
  local ok, completions = pcall(function()
    return codeium.get_completions(params)
  end)
  
  -- Handle errors gracefully
  if not ok or not completions then
    callback({})
    return
  end
  
  -- Return completions
  callback(completions)
end

return M
