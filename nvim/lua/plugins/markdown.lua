return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_refresh_slow = true
			vim.g.mkdp_port = 8199
		end,
	},
	{
		"ellisonleao/glow.nvim",
		lazy = true,
		cmd = "Glow",
		ft = { "markdown", "md" },
		opts = {
			style = "dark",
		},
	},
}
