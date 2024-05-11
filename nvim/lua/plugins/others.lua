return {
	{ "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
	{ "tpope/vim-unimpaired", event = { "BufReadPost", "BufNewFile" } },
	{ "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
	{ "lewis6991/gitsigns.nvim", },
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
