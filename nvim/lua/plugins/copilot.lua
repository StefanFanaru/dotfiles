return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "<C-]>",
					jump_next = "<C-[>",
					accept = "<CR>",
				},
				layout = {
					position = "bottom",
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					--
					accept = "<C-y>",
					accept_word = false,
					accept_line = false,
					next = "<C-]>",
					prev = "<C-[>",
					dismiss = "<C-\\>",
				},
			},
			filetypes = {
				yaml = false,
				json = false,
				toml = false,
				-- markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node",
			server_opts_overrides = {},
		})
		vim.keymap.set("n", "<leader>co", function()
			require("copilot.panel").open({ "bottom", 0.4 })
		end, { noremap = true, silent = true, desc = "Copilot panel" })

		vim.keymap.set("n", "<leader>cr", function()
			require("copilot.panel").refresh()
		end, { noremap = true, silent = true, desc = "Copilot refresh panel" })

		vim.keymap.set("i", "<Esc>", "<Esc>", { noremap = true, silent = true })
	end,
}
