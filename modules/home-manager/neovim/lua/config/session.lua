-- lua/config/session.lua

-- Function to check if a file exists
local function file_exists(file)
  local f = io.open(file, "r")
  if f then
    f:close()
    return true
  else
    return false
  end
end

-- Path to the session file
local session_file = ".session.vim"

-- Create an autocommand group for session management
local session_group = vim.api.nvim_create_augroup("SessionManagement", { clear = true })

-- Auto-load session when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
  group = session_group,
  callback = function()
    if file_exists(session_file) then
      vim.cmd("source " .. session_file)
    end
  end,
})

-- Optional: Auto-save session when exiting Neovim
vim.api.nvim_create_autocmd("VimLeave", {
  group = session_group,
  callback = function()
    vim.cmd("mksession! " .. session_file)
  end,
})
