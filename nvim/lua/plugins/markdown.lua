return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown", "md" },
		build = "cd app && yarn install",
		lazy = true
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
