local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Quick Exits and Navigation
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })
map({ "n", "v" }, "<M-h>", "^", { desc = "Go to line start" })
map({ "n", "v" }, "<M-l>", "$", { desc = "Go to line end" })
map("v", "<M-l>", "$h", { desc = "Go to line end minus one" })

-- Window Management (<leader>w prefix)
map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Tab Management (<leader>t prefix)
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tj", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<leader>tk", "<cmd>tabp<CR>", { desc = "Previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Move buffer to new tab" })

-- File Explorer and Search (<leader>e, <leader>f prefix)
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Telescope (<leader>f prefix)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find text" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Find symbols" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
map("n", "<leader>fy", "<cmd>Telescope neoclip<CR>", { desc = "Clipboard history" })

-- Buffer Management (<leader>b prefix)
map("n", "<leader>bb", function()
  require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
    sort_mru = true,
    sort_lastused = true,
    initial_mode = "normal",
    layout_config = { preview_width = 0.45 },
  }))
end, { desc = "Browse buffers" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bx", ":bdelete<CR>", { desc = "Close buffer" })

-- Git Operations (<leader>g prefix)
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Git diff" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })

-- LSP Operations (<leader>l prefix)
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Show hover" })

-- Code Navigation and Editing
map("n", "<leader>a", "<cmd>AerialToggle<CR>", { desc = "Toggle code outline" })
map("v", "<", "<gv", { desc = "Unindent line" })
map("v", ">", ">gv", { desc = "Indent line" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Harpoon Marks (<leader>h prefix)
map("n", "<leader>ha", function() require("harpoon.mark").add_file() end, { desc = "Add file to harpoon" })
map("n", "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Show harpoon menu" })
map("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, { desc = "Navigate to file 1" })
map("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, { desc = "Navigate to file 2" })
map("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end, { desc = "Navigate to file 3" })

-- Misc Operations
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Improved scrolling
local scroll_percentage = 0.35
map("n", "<C-d>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
  vim.cmd("normal! " .. lines .. "jzz")
end, { desc = "Scroll down" })

map("n", "<C-u>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
  vim.cmd("normal! " .. lines .. "kzz")
end, { desc = "Scroll up" })
