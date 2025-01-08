-- cmp_engine.lua
local M = {}

-- Default engine for nvim-cmp
M.DEFAULT = "nvim-cmp"

-- Get the current completion engine
function M.get()
  return M.DEFAULT
end

-- Check if a specific completion engine is active
function M.has(engine)
  return M.get() == engine
end

return M
