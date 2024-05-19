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
		custom_highlights = function(colors)
			return {
				FloatBorder = { fg = colors.lavender },

				NvimTreeEndOfBuffer = { fg = colors.mantle },
				-- NvimTreeIndentMarker = { fg = colors.surface0 },

				CmpItemMenu = { fg = colors.overlay2 },

				TelescopeNormal = { link = "NormalFloat" },

				MiniIndentscopeSymbol = { fg = colors.surface1 },

				CmpBorder = { fg = colors.pink },
				CopilotSuggestion = { fg = colors.overlay2 },
				LineNr = { fg = colors.overlay2 },
				-- Pmenu = { bg = "#3c3836" },
			}
		end,
		integrations = {
			lsp_trouble = true,
			which_key = true,
		},
	},
	init = function()
		vim.cmd("colorscheme catppuccin")
		-- Fix highlight for lsp-signature.nvim plugin to show currently active parameter in the signature
		vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "#000000", bg = "#89b4fa" })
		-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#3c3836" })
		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828" })
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})

		-- Diagnostics highlight sign column
		for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
			vim.fn.sign_define("DiagnosticSign" .. diag, {
				text = "",
				texthl = "DiagnosticSign" .. diag,
				linehl = "",
				numhl = "DiagnosticSign" .. diag,
			})
		end
	end,
}
