return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft["markdown"] = { "markdownlint", "codespell" }
			lint.linters_by_ft["json"] = { "jsonlint" }
			lint.linters_by_ft["terraform"] = { "tflint" }
			lint.linters_by_ft["typescript"] = { "eslint" }
			lint.linters_by_ft["groovy"] = { "npm-groovy-lint" }
			lint.linters_by_ft["dockerfile"] = { "hadolint" }

			local npm_groovy_lint = lint.linters["npm-groovy-lint"]
			npm_groovy_lint.ignore_exitcode = true
			npm_groovy_lint.args = {
				"--config=" .. dot_files_env .. "/dependencies/groovy-lsp/npm_groovy_lint.json",
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
					require("lint").try_lint("codespell")
				end,
			})
		end,
	},
}
