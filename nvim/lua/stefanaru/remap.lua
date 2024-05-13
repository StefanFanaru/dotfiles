local utils = require("stefanaru.utils")
local map = utils.mapkey

-- Show Netrw directory listing when pressing \ twice
map("n", "\\\\", vim.cmd.Oil, "Show Oil")

-- Move lines when they are visually selected
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Add new empty lines
map("n", "<Enter>", "o<ESC>")

-- Keep cursor in place
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- When pasting over preserve initial yanked value
map("x", "<leader>p", [["_dP]], "Paste while keeping registry")

-- Allow copying into system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], "Copy to system registry")
map("n", "<leader>Y", [["+Y]], "Copy to system registry")

-- Make C-c work in visual block
map("i", "<C-c>", "<Esc>")

-- Search and replace
map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Seach and replace current word")

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, "Go to previous [D]iagnostic message")
map("n", "]d", vim.diagnostic.goto_next, "Go to next [D]iagnostic message")
map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")
map("n", "<leader>q", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

-- Exit terminal mode easier
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- Exit hlsearch
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", "Move focus to the left window")
map("n", "<C-l>", "<C-w><C-l>", "Move focus to the right window")
map("n", "<C-j>", "<C-w><C-j>", "Move focus to the lower window")
map("n", "<C-k>", "<C-w><C-k>", "Move focus to the upper window")

-- Toggle max column line
map("n", "<leader>1", function()
	if vim.opt.colorcolumn:get()[1] == "120" then
		vim.opt.colorcolumn = ""
	else
		vim.opt.colorcolumn = "120"
	end
end, "Toggle max column line")

-- the max column line that appears on <leader>1 will be grey
vim.cmd([[highlight ColorColumn ctermbg=grey guibg=grey]])
-- map("i", "<>", "<Esc>o")
