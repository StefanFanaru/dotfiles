return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavour = "mocha",
		no_italic = true,
		color_overrides = {
			mocha = {
				base = "#161616",
				mantle = "#262626",
				crust = "#363636",
			},
		},
		transparent_background = true,
	},
	init = function()
		vim.cmd("colorscheme catppuccin")
		-- Fix highlight for lsp-signature.nvim plugin to show currently active parameter in the signature
		vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "#000000", bg = "#89b4fa" })
	end,
}
