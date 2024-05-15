return {

	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lint = require("lint")
			-- lint.linters_by_ft = {
			--   markdown = { 'markdownlint' },
			-- }

			lint.linters_by_ft["markdown"] = { "markdownlint","codespell" }
			lint.linters_by_ft["json"] = { "jsonlint" }
			lint.linters_by_ft["dockerfile"] = { "hadolint" }
			lint.linters_by_ft["terraform"] = { "tflint" }
			-- If you want  to enable default eslint from vscode language servers, then comment this,
			-- and go to lsp.lua and uncomment eslint block next to eslint_d
			lint.linters_by_ft["typescript"] = { "eslint_d" }
			lint.linters_by_ft["groovy"] = { "npm-groovy-lint" }

			lint.linters_by_ft["dockerfile"] = { "hadolint" }
			lint.linters_by_ft["terraform"] = { "tflint" }

			local npm_groovy_lint = lint.linters["npm-groovy-lint"]
			npm_groovy_lint.ignore_exitcode = true
			npm_groovy_lint.args = {
				"--config=" .. dot_files_env .. "/dependencies/groovy-lsp/npm_groovy_lint.json",
			}

			-- To allow other plugins to add linters to require('lint').linters_by_ft,
			-- instead set linters_by_ft like this:
			-- lint.linters_by_ft = lint.linters_by_ft or {}
			-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
			--
			-- However, note that this will enable a set of default linters,
			-- which will cause errors unless these tools are available:
			-- {
			--   clojure = { "clj-kondo" },
			--   dockerfile = { "hadolint" },
			--   inko = { "inko" },
			--   janet = { "janet" },
			--   json = { "jsonlint" },
			--   markdown = { "vale" },
			--   rst = { "vale" },
			--   ruby = { "ruby" },
			--   terraform = { "tflint" },
			--   text = { "vale" }
			-- }
			--
			-- You can disable the default linters by setting their filetypes to nil:
			-- lint.linters_by_ft['clojure'] = nil
			-- lint.linters_by_ft['dockerfile'] = nil
			-- lint.linters_by_ft['inko'] = nil
			-- lint.linters_by_ft['janet'] = nil
			-- lint.linters_by_ft['json'] = nil
			-- lint.linters_by_ft['markdown'] = nil
			-- lint.linters_by_ft['rst'] = nil
			-- lint.linters_by_ft['ruby'] = nil
			-- lint.linters_by_ft['terraform'] = nil
			-- lint.linters_by_ft['text'] = nil

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
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
