local augroup = vim.api.nvim_create_augroup
local StefanaruGroup = augroup("Stefanaru", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
		md= "markdown"
	},
})


autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = StefanaruGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Function to open URL on gx
M = {}
M.HandleURL = function()
	local url = string.match(vim.fn.getline("."), "[a-z]*://[^ >,;]*")
	if url ~= "" then
		vim.cmd("exec \"!open '" .. url .. "'\"")
	else
		vim.cmd('echo "No URI found in line."')
	end
end
vim.api.nvim_set_keymap("n", "gx", [[ <Cmd>lua M.HandleURL()<CR> ]], {})

-- dos2unix
M.dosToUnix = function()
  vim.bo.fileformat = 'unix'
  vim.bo.bomb = false
  vim.opt.encoding = 'utf-8'
  vim.opt.fileencoding = 'utf-8'
end
vim.cmd([[command! Dos2unix lua require('stefanaru.utils').dosToUnix()]])

return M
