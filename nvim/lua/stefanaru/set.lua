dot_files_env = os.getenv("DOT_FILES")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.conceallevel = 1
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = true
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

vim.g.mapleader = " "

-- Netrw settings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.g.have_nerd_font = true
vim.opt.showmode = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.inccommand = "split"

if os.getenv("IS_BASH") == "true" or os.getenv("IS_ZSH") == true then
	local home = os.getenv("HOME")
	vim.opt.undodir = home .. "/bin/.vim/undotree"
	vim.opt.directory = home .. "/bin/.vim/swap"
else
	vim.opt.undodir = os.getenv("/c/vimbackups/undotree")
end

if os.getenv("IS_BASH") == "true" then
	vim.opt.shellcmdflag = "-c"
	-- vim.opt.ssl = true
end

vim.opt.smoothscroll = true
