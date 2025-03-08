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
		md = "markdown",
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

autocmd({ "TermOpen" }, {
	group = StefanaruGroup,
	pattern = "*",
	command = "setlocal nonumber norelativenumber",
})

autocmd("BufWritePre", {
	group = StefanaruGroup,
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf, lsp_fallback = true })
		-- if vim.bo[0].filetype == "cs" then
		-- 	require("csharp").fix_usings()
		-- end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		-- if vim.bo[0].filetype == "cs" then
		-- 	vim.cmd("CSFixUsings")
		-- end
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 1
	end,
})

M = {}

-- Function to open URL on gx
M.HandleURL = function()
	local url = string.match(vim.fn.getline("."), "[a-z]*://[^ >,;]*")
	if url ~= nil then
		url = string.gsub(url, '[%)"%]', "")
	end
	if url ~= "" then
		vim.cmd("exec \"!open '" .. url .. "'\"")
	else
		vim.cmd('echo "No URI found in line."')
	end
end
vim.api.nvim_set_keymap("n", "gx", [[ <Cmd>lua M.HandleURL()<CR> ]], {})

-- dos2unix
M.dosToUnix = function()
	vim.bo.fileformat = "unix"
	vim.bo.bomb = false
	vim.opt.encoding = "utf-8"
	vim.opt.fileencoding = "utf-8"
end
vim.cmd([[command! Dos2unix lua require('stefanaru.utils').dosToUnix()]])

M.generate_guid = function()
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

M.mapkey = function(mode, keys, func, desc)
	if desc == nil or desc == "" then
		vim.keymap.set(mode, keys, func, { noremap = true })
	else
		vim.keymap.set(mode, keys, func, { desc = desc, noremap = true })
	end
end

function M.printTable(t)
	print("{")
	for k, v in pairs(t) do
		if type(v) == "table" then
			print("\t" .. k .. " = ")
			M.printTable(v)
		else
			print("\t" .. k .. " = " .. tostring(v))
		end
	end
	print("}")
end

function M.load_vimscript(filename)
	local escaped_filename = vim.fn.fnameescape(filename)
	vim.cmd("source " .. escaped_filename)
end

function M.get_lsp_client(client_id)
	local client = vim.lsp.get_client_by_id(client_id)
	local client_name = client and client.name or "Unknown"
	return client_name
end

-- Function to copy the current file path to the clipboard
function CopyFilePathToClipboard()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		print("No file path to copy")
		return
	end
	vim.fn.system("echo -n " .. vim.fn.shellescape(file_path) .. " | xclip -selection clipboard")
	print("File path copied to clipboard: " .. file_path)
end

-- Command to copy the file path
vim.api.nvim_create_user_command("FilePathCopy", CopyFilePathToClipboard, {})

function M.monkey_patch_semantic_tokens(client)
	if not client.is_hacked then
		client.is_hacked = true

		-- let the runtime know the server can do semanticTokens/full now
		client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
			semanticTokensProvider = {
				full = true,
			},
		})

		-- monkey patch the request proxy
		local request_inner = client.request
		client.request = function(method, params, handler)
			if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
				return request_inner(method, params, handler)
			end

			local function find_buf_by_uri(search_uri)
				local bufs = vim.api.nvim_list_bufs()
				for _, buf in ipairs(bufs) do
					local name = vim.api.nvim_buf_get_name(buf)
					local uri = "file://" .. name
					if uri == search_uri then
						return buf
					end
				end
			end

			local doc_uri = params.textDocument.uri

			local target_bufnr = find_buf_by_uri(doc_uri)
			local line_count = vim.api.nvim_buf_line_count(target_bufnr)
			local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

			return request_inner("textDocument/semanticTokens/range", {
				textDocument = params.textDocument,
				range = {
					["start"] = {
						line = 0,
						character = 0,
					},
					["end"] = {
						line = line_count - 1,
						character = string.len(last_line) - 1,
					},
				},
			}, handler)
		end
	end
end
return M
