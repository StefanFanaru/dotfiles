local groovy_config = "--config=" .. dot_files_env .. "/dependencies/groovy-lsp/npm_groovy_lint.json"
return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = true,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { { "prettierd", "prettier" } },
			scss = { { "prettierd", "prettier" } },
			css = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			yaml = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },
			-- markdown = { { "prettierd", "prettier" } },
			groovy = { "npm_groovy_lint" },
			sh = { "shfmt" },
			["*"] = { "codespell" },
			["_"] = { "trim_whitespace" },
		},
		formatters = {
			npm_groovy_lint = {
				command = "npm-groovy-lint",
				stdin = false,
				args = {
					"--format",
					groovy_config,
					"$FILENAME",
					"--nolintafter",
					"--failon",
					"none",
				},
			},
		},
	},
}
