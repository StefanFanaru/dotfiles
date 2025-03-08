local groovy_config = "--config=" .. dot_files_env .. "/dependencies/groovy-lsp/npm_groovy_lint.json"
return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
				-- if vim.bo[0].filetype == "cs" then
				-- 	vim.cmd("CSFixUsings")
				-- end
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			-- markdown = { { "prettierd", "prettier" } },
			groovy = { "npm_groovy_lint" },
			terraform = { "terraform_fmt" },
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
