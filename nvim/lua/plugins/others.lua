return {
	{ "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
	{ "tpope/vim-unimpaired", event = { "BufReadPost", "BufNewFile" } },
	{
		"nvim-pack/nvim-spectre",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
		end,
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"Wansmer/treesj",
		keys = { "<space>bb" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false })
			vim.keymap.set("n", "<leader>bb", require("treesj").toggle, { desc = "Toggle treesj (split / join)" })
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false, keywords = { TODO = { alt = { "todo" } } } },
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false, -- last release is way too old
	},
	{ "folke/neodev.nvim", opts = {} },
}
