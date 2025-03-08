-- Highlight, edit, and navigate code
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"vim",
				"vimdoc",
				"css",
				"scss",
				"json",
				"yaml",
				"angular",
				"typescript",
				"hcl",
				"groovy",
				"c_sharp",
				"markdown_inline",
			},
			auto_install = true,
			context_commentstring = { enable = true, enable_autocmd = false },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gns",
					node_incremental = "gni",
					scope_incremental = "gsi",
					node_decremental = "gnd",
				},
			},
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ii"] = "@conditional.inner",
						["ai"] = "@conditional.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["it"] = "@comment.inner",
						["at"] = "@comment.outer",
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]]"] = { query = "@function.outer", desc = "Next func start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]l"] = { query = { "@loop.inner", "@loop.outer" }, desc = "Next loop inner/outer" },
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]["] = { query = "@function.outer", desc = "Next func end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
					},
					goto_previous_start = {
						["[["] = { query = "@function.outer", desc = "Previous func start" },
						["[c"] = { query = "@class.outer", desc = "Previous class start" },
					},
					goto_previous_end = {
						["[]"] = { query = "@function.outer", desc = "Previous func start" },
						["[C"] = { query = "@class.outer", desc = "Previous func end" },
					},
					goto_next = {
						["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
					},
					goto_previous = {
						["[i"] = { query = "@conditional.outer", desc = "Previous conditional" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>cp"] = { query = "@parameter.inner", desc = "Swap param with next" },
						["<leader>cf"] = { query = "@function.outer", desc = "Swap func with next" },
					},
					swap_previous = {
						["<leader>cP"] = { query = "@parameter.inner", desc = "Swap param with prev" },
						["<leader>cF"] = { query = "@function.outer", desc = "Swap func with next" },
					},
				},
				lsp_interop = {
					enable = true,
					border = "rounded",
					floating_preview_opts = {},
					peek_definition_code = {
						["<leader>df"] = { query = "@function.outer", desc = "Show func def" },
						["<leader>dF"] = { query = "@class.outer", desc = "Show class def" },
					},
				},
			},
		},
		config = function(_, opts)
			-- Prefer git instead of curl in order to improve connectivity in some environments
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			vim.treesitter.language.register("groovy", "jenkins")

			vim.schedule(function()
				require("lazy").load({ plugins = { "nvim-treesitter-textobjects" } })
			end)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		enabled = true,
		opts = { mode = "cursor", max_lines = 3 },
		keys = {
			{
				"<leader>tu",
				function()
					require("treesitter-context").toggle()
				end,
				desc = "Toggle Treesitter Context",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
		config = function()
			-- NOTE: Make more moves repeatable
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			--  ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, "'", ts_repeat_move.repeat_last_move_previous)

			-- Make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			local gs = require("gitsigns")

			local next_hunk_repeat, prev_hunk_repeat =
				ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

			vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat, { desc = "Git Hunk repeat Next" })
			vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat, { desc = "Git Hunk repeat Next" })
		end,
	},
}
