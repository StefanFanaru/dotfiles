return {
	{ "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
	{ "tpope/vim-unimpaired", event = { "BufReadPost", "BufNewFile" } },
	{ "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" } },
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false, keywords = { TODO = { alt = { "todo" } } } },
	},
	{ "lewis6991/gitsigns.nvim" },
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false, -- last release is way too old
	},
}
