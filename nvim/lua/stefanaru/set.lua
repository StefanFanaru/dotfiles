dot_files_env = os.getenv("DOT_FILES") or ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
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
vim.opt.ruler = false

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

local banned_messages = {
	"Initializing Roslyn client",
	"Running dotnet restore",
	"Determining projects",
	"Running restore on",
	"Restore started",
	"All projects",
	"Duplicate 'PackageReference' items found",
	"Restore complete",
}

local notify = vim.notify

vim.notify = function(msg, ...)
	for _, banned in ipairs(banned_messages) do
		if msg:find(banned) then
			return
		end
	end
	notify(msg, ...)
end

vim.filetype.add({
	-- Detect and assign filetype based on the extension of the filename
	extension = {
		mdx = "mdx",
		log = "log",
		conf = "conf",
		env = "dotenv",
	},
	-- Detect and apply filetypes based on the entire filename
	filename = {
		[".env"] = "dotenv",
		["env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
	},
	-- Detect and apply filetypes based on certain patterns of the filenames
	pattern = {
		-- INFO: Match filenames like - ".env.example", ".env.local" and so on
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})
