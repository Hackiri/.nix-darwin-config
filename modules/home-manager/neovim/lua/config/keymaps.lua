local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Better window navigation
map("n", "<C-h>", "<C-w>h") --
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
map("n", "<leader>p", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>n", ":bnext<CR>", { desc = "Next buffer" })

-- Clear highlights
map("n", "<leader>h", "<cmd>nohlsearch<CR>")

-- Better paste
map("v", "p", '"_dP')

-- Keymap to open neoclip via Telescope
map("n", "<leader>fy", "<cmd>Telescope neoclip<CR>", { desc = "Clipboard History (neoclip)" })

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("v", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Visual Block --
-- Move text up and down
map("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move block down" })
map("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move block up" })

-- Plugin specific mappings
-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>bb", function()
  require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
    sort_mru = true,
    sort_lastused = true,
    initial_mode = "normal",
    layout_config = {
      preview_width = 0.45,
    },
  }))
end, { desc = "Browse buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- LSP
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gd", vim.lsp.buf.definition)
map("n", "K", vim.lsp.buf.hover)
map("n", "gi", vim.lsp.buf.implementation)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "gr", vim.lsp.buf.references)
map("n", "<leader>f", vim.lsp.buf.format)

-- Treesitter
map("n", "<leader>tt", "<cmd>InspectTree<cr>", { desc = "Inspect Treesitter Tree" }) -- Show treesitter tree
map("n", "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<cr>", { desc = "Show TS Highlight Group" }) -- Show highlight group

-- Diagnostic
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>d", vim.diagnostic.open_float)
map("n", "<leader>q", vim.diagnostic.setloclist)

-- Quick exit from insert mode
map("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })

-- Quick line navigation (using Alt/Meta instead of g prefix)
map({ "n", "v" }, "<M-h>", "^", { desc = "Go to the beginning of line" })
map({ "n", "v" }, "<M-l>", "$", { desc = "Go to the end of line" })
-- In visual mode, after going to the end of the line, come back 1 character
map("v", "<M-l>", "$h", { desc = "Go to the end of line minus one" })

-- Improved scrolling with cursor centered
local scroll_percentage = 0.35
map("n", "<C-d>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
  vim.cmd("normal! " .. lines .. "jzz")
end, { noremap = true, silent = true })

map("n", "<C-u>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
  vim.cmd("normal! " .. lines .. "kzz")
end, { noremap = true, silent = true })

-- Additional plugin mappings can be added here
