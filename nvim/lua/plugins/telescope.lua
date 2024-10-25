local map = require("stefanaru.utils").mapkey
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		local actions = require("telescope.actions")
		local custom_picker_options = {
			previewer = true,
			hidden = true,
		}

		local trouble = require("trouble.sources.telescope")

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<c-enter>"] = "to_fuzzy_refine",
						["<C-e>"] = require("telescope.actions.layout").toggle_preview,
						["<C-t>"] = trouble.open,
					},
					n = { ["<C-t>"] = trouble.open },
				},
				layout_strategy = "vertical",
				layout_config = {
					prompt_position = "top",
				},
				file_ignore_patterns = {
					".git/",
					".cache",
					"build/",
					"%.class",
					"%.pdf",
					"%.mkv",
					"%.mp4",
					"%.zip",
					"bin/",
					"obj/",
					".trash/",
					".idea",
					".obsidian/",
					"node_modules/",
				},
			},
			pickers = {
				git_files = custom_picker_options,
				find_files = custom_picker_options,
				live_grep = custom_picker_options,
				current_buffer_fuzzy_find = custom_picker_options,
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		local customPickers = require("stefanaru.helpers.telescopePickers")
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		local builtin = require("telescope.builtin")

		map("n", "<leader>sf", customPickers.prettyFilesPicker, "[S]earch [F]iles")
		map("n", "<leader>sg", customPickers.prettyGrepPicker, "[S]earch [G]rep")
		map("n", "<leader>sh", builtin.help_tags, "[S]earch [H]elp")
		map("n", "<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
		map("n", "<leader>ss", builtin.builtin, "[S]earch [S]elect Telescope")
		map("n", "<leader>sg", builtin.live_grep, "[S]earch by [G]rep")
		map("n", "<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
		map("n", "<leader>sr", builtin.resume, "[S]earch [R]esume")
		map("n", "<leader>s.", builtin.oldfiles, '[S]earch Recent Files ("." for repeat)')
		map("n", "<leader>sl", builtin.lsp_document_symbols, "[S]each [L]sp document symbols")
		map("n", "<leader>/", builtin.current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer")
		map("n", "<leader>sb", builtin.buffers, "[ ] Find existing buffers")

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
