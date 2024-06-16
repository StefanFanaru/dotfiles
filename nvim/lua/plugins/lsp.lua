local utils = require("stefanaru.utils")
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "Hoffs/omnisharp-extended-lsp.nvim", ft = { "cs" } },
			{ "folke/neodev.nvim", opts = {} },
			-- Experimental roslyn vs code dev kit LSP integration
			-- https://github.com/jmederosalvarado/roslyn.nvim
			"jmederosalvarado/roslyn.nvim",
			-- Enhanced signature helpers, loaded on LspAttach
			{
				"ray-x/lsp_signature.nvim",
				event = "LspAttach",
				opts = {},
			},
			{
				"pmizio/typescript-tools.nvim",
				dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
				opts = {},
				ft = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			},
		},
		opts = {
			inlay_hints = {
				enabled = true,
			},
			codelens = {
				enabled = true,
			},
			diagnostics = {
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				virtual_text = {
					spacing = 4,
					prefix = "●",
					float = { border = "rounded" },
				},
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local client_name = utils.get_lsp_client(event.data.client_id)
					if client_name == "copilot" then
						return
					end

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", function()
						if client_name == "omnisharp" then
							require("omnisharp_extended").lsp_definition()
						elseif require("obsidian").util.cursor_on_markdown_link() then
							vim.cmd("ObsidianFollowLink")
						else
							require("telescope.builtin").lsp_definitions()
						end
					end, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]symbols"
					)

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.

					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = event.buf, desc = "LSP: [C]ode [A]ction" }
					)
					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					map("<leader>hi", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
					end, "Inlay [H]ints")

					map("<leader>rlsp", ":LspRestart<CR>", "Restart LSP")

					map("<leader>qs", ":CSFixUsings<CR>", "Fix usings")

					map("<C-s>", require("lsp_signature").toggle_float_win, "Toggle signature help")
					require("lsp_signature").on_attach({
						hint_enable = false,
						floating_window = false,
						toggle_key = "<C-s>",
					}, event.buf)
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local on_attach = function(client, bufnr)
				return
				-- local fix_usings = function()
				-- 	local action = {
				-- 		kind = "quickfix",
				-- 		data = {
				-- 			CustomTags = { "RemoveUnnecessaryImports" },
				-- 			TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
				-- 			CodeActionPath = { "Remove unnecessary usings" },
				-- 			Range = {
				-- 				["start"] = { line = 0, character = 0 },
				-- 				["end"] = { line = 0, character = 0 },
				-- 			},
				-- 			UniqueIdentifier = "Remove unnecessary usings",
				-- 		},
				-- 	}
				-- 	client.request("codeAction/resolve", action, function(err, resolved_action)
				-- 		print("Resolved code action: " .. vim.inspect(resolved_action))
				-- 		if err then
				-- 			print("Error resolving code action: " .. err)
				-- 			return
				-- 		end
				-- 		vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
				-- 	end)
				-- end
				-- vim.keymap.set("n", "<leader>qs", fix_usings, { buffer = bufnr, desc = "LSP: " .. "Fix usings" })
			end
			local servers = {
				cssls = {},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							format = { enable = true },
							validate = { enable = true },
						},
					},
				},
				lua_ls = {
					on_attach = function() end,
					settings = {
						Lua = {
							hint = { enable = true },
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				prettier = {},

				bashls = {
					cmd = { "bash-language-server", "start" },
					filetypes = { "sh", "bash" },
				},
				shfmt = {},
				shellcheck = {},
				eslint_d = {
					settings = {
						workingDirectory = {
							mode = "location",
						},
					},
				},
				gopls = {},
				pyright = {},
				vale_ls = {},
				-- omnisharp = {
				-- 	cmd = { "/home/stefanaru/bin/omnisharp/OmniSharp" },
				-- 	handlers = {
				-- 		["textDocument/definition"] = require("omnisharp_extended").definition_handler,
				-- 		["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
				-- 		["textDocument/references"] = require("omnisharp_extended").references_handler,
				-- 		["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
				-- 	},
				-- 	settings = {
				-- 		FormattingOptions = {
				-- 			OrganizeImports = true,
				-- 		},
				-- 		RoslynExtensionsOptions = {
				-- 			EnableImportCompletion = true,
				-- 		},
				-- 	},
				-- },
			}

			local groovy_lsp_jar = dot_files_env .. "/dependencies/groovy-lsp/groovy-language-server-all.jar"
			require("lspconfig").groovyls.setup({

				filetypes = { "groovy" },

				capabilities = capabilities,
				cmd = {
					"java",
					"-jar",
					groovy_lsp_jar,
				},
			})

			require("roslyn").setup({
				dotnet_cmd = "dotnet",
				roslyn_version = "4.11.0-1.24209.10",
				on_attach = function(client) end,
				capabilities = capabilities,
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
				},
			})

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"tflint",
				"jsonlint",
				"hadolint",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
