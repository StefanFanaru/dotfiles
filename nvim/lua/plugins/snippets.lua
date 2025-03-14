if not vim.snippet then
	print("Native snippets are only supported on Neovim >= 0.10.0")
	return {}
end

return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = "make install_jsregexp",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			event = "InsertEnter",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},

		config = function()
			local ls = require("luasnip")
			ls.filetype_extend("javascript", { "jsdoc" })

			-- --- TODO: What is expand?
			-- vim.keymap.set({ "i" }, "<C-s>e", function()
			-- 	ls.expand()
			-- end, { silent = true })
			--
			-- vim.keymap.set({ "i", "s" }, "<C-s>;", function()
			-- 	ls.jump(1)
			-- end, { silent = true })
			-- vim.keymap.set({ "i", "s" }, "<C-s>,", function()
			-- 	ls.jump(-1)
			-- end, { silent = true })
			--
			-- vim.keymap.set({ "i", "s" }, "<C-E>", function()
			-- 	if ls.choice_active() then
			-- 		ls.change_choice(1)
			-- 	end
			-- end, { silent = true })
		end,
	},
}
