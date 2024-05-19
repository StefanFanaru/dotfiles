return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	cmd = { "ObsidianNew", "ObsidianSearch", "ObsidianQuickSearch", "ObsidianTemplate" },
	event = {
		"BufReadPre oil:///mnt/f/obsidian/stefanaru-second-brain/*",
		"BufReadPre /mnt/f/obsidian/stefanaru-second-brain/*.md",
		"BufNewFile /mnt/f/obsidian/stefanaru-second-brain/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "stefanaru-scond-brain",
				path = "/mnt/f/obsidian/stefanaru-second-brain",
			},
		},
		ui = {
			update_debounce = 50,
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		-- Put new notes in the New directory, also use title instead of id when given
		note_path_func = function(spec)
			-- This is equivalent to the default behavior.
			local note_title = spec.title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			return "/mnt/f/obsidian/stefanaru-second-brain/Inbox/" .. note_title .. ".md"
		end,
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			vim.fn.jobstart({ "xdg-open", url }) -- linux
		end,
		disable_frontmatter = true,
		templates = {
			folder = "Assets/Templates",
			date_format = "%d %b %Y - %H:%M",
			time_format = "%H:%M",
		},
		attachments = {
			img_folder = "Assets",
		},
	},
	config = function(_, opts)
		require("obsidian").setup(opts)
		local utils = require("stefanaru.utils")
		local map = utils.mapkey

		function ObsidianNewImage()
			local title = utils.generate_guid()
			vim.cmd("ObsidianPasteImg " .. title .. "<CR>")
		end

		map("n", "<leader>oi", ":lua ObsidianNewImage()<CR>", "Paste image")
		map("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", "Open note in app")
		map("n", "<leader>ol", "<cmd>ObsidianBacklinks<CR>", "Show links")
		map("n", "<leader>ot", "<cmd>ObsidianToggleCheckbox<CR>", "Toggle checkbox")

		local function insert_template()
			vim.cmd("ObsidianTemplate " .. "main-template")
			-- Take care of the references first!
			vim.cmd("normal! ddi[[]]")
			vim.cmd("normal! h")
		end

		-- New note.
		-- Help to verify that there is no other similar note
		-- before creating a new one.
		vim.keymap.set({ "v", "n" }, "<leader>sf", function()
			local customPickers = require("stefanaru.helpers.telescopePickers")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			customPickers.prettyFilesPicker({
				prompt_title = "Notes",
				find_command = { "fd", "--type", "f", "--extension", "md" },
				attach_mappings = function(prompt_bufnr, map_telescope)
					-- Create new note with the input text in telescope
					map_telescope("i", "<C-y>", function()
						local current_input = action_state.get_current_line()
						actions.close(prompt_bufnr)
						-- Create a new note with the selected file name
						vim.cmd("ObsidianNew " .. current_input)
						insert_template()
					end)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						-- Open selected file in a buffer
						vim.api.nvim_command("edit " .. selection[1])
					end)
					return true
				end,
			})
		end, { desc = "Notes" })

		-- Link selection with a note
		vim.keymap.set("v", "<leader>ol", function()
			local function save_visual_selection()
				vim.cmd([[execute "normal! \<esc>"]])
				local bufnr = vim.api.nvim_get_current_buf()
				-- vim.fn.getpos("'<")
				print(vim.fn.getpos("'<")[2])
				local pos_start = vim.api.nvim_buf_get_mark(bufnr, "<")
				local pos_end = vim.api.nvim_buf_get_mark(bufnr, ">")
				utils.printTable(pos_start)
				local ls, cs, le, ce = pos_start[1], pos_start[2] + 1, pos_end[1], pos_end[2] + 1
				print(ls, cs, le, ce)
				local mode = vim.fn.visualmode()

				return { start_line = ls, start_col = cs, end_line = le, end_col = ce, mode = mode }
			end
			local selection = save_visual_selection()
			local customPickers = require("stefanaru.helpers.telescopePickers")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			-- Function to restore the visual selection
			local function restore_visual_selection(selection)
				print(selection.start_line, selection.start_col, selection.end_line, selection.end_col, selection.mode)
				vim.api.nvim_win_set_cursor(0, { selection.start_line, selection.start_col - 1 })
				vim.cmd("normal! v")
				vim.api.nvim_win_set_cursor(0, { selection.end_line, selection.end_col - 1 })
			end

			customPickers.prettyFilesPicker({
				prompt_title = "Link note",
				find_command = { "fd", "--type", "f", "--extension", "md" },
				attach_mappings = function(prompt_bufnr, map_telescope)
					map_telescope("i", "<C-y>", function()
						local current_input = action_state.get_current_line()
						actions.close(prompt_bufnr)
						-- Create a new note with the selected file name
						print(current_input)
						vim.cmd("ObsidianExtractNote " .. current_input)
						-- Some cleanup
						vim.cmd("normal! jddo")
						insert_template()
					end)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection_path = action_state.get_selected_entry()
						print(selection_path[1])
						restore_visual_selection(selection)
						vim.cmd("ObsidianLink " .. selection_path[1])
					end)
					return true
				end,
			})
		end, { desc = "New note" })
	end,
}
