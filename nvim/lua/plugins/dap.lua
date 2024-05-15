return {
	{
		"mfussenegger/nvim-dap",
		ft = "cs",
		config = function()
			local dap = require("dap")
			dap.adapters.coreclr = {
				type = "executable",
				command = "/usr/local/bin/netcoredbg/netcoredbg",
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}

			vim.api.nvim_set_keymap(
				"n",
				"<F5>",
				'<Cmd>lua require("csharp").debug_project()<CR>',
				{ noremap = true, silent = true, desc = "Continue execution" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<F10>",
				'<Cmd>lua require"dap".step_over()<CR>',
				{ noremap = true, silent = true, desc = "Step over" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<F11>",
				'<Cmd>lua require"dap".step_into()<CR>',
				{ noremap = true, silent = true, desc = "Step into" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<F12>",
				'<Cmd>lua require"dap".step_out()<CR>',
				{ noremap = true, silent = true, desc = "Step out" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>bt",
				'<Cmd>lua require"dap".toggle_breakpoint()<CR>',
				{ noremap = true, silent = true, desc = "Toggle breakpoint" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>bc",
				'<Cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
				{ noremap = true, silent = true, desc = "Set breakpoint with condition" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>bi",
				'<Cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
				{ noremap = true, silent = true, desc = "Set log point with message" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>br",
				'<Cmd>lua require"dap".repl.open()<CR>',
				{ noremap = true, silent = true, desc = "Open debugger REPL" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>bl",
				'<Cmd>lua require"dap".run_last()<CR>',
				{ noremap = true, silent = true, desc = "Run last debug configuration" }
			)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					-- Use a table to apply multiple mappings
					expand = "<Space>",
					open = "o",
					remove = "d",
					edit = "e",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.6 },
							"console",
						},
						size = 0.25, -- 25% of total lines
						position = "bottom",
					},
					{
						elements = {
							"breakpoints",
						},
						size = 30, -- 40 columns
						position = "left",
					},
				},
				controls = {
					enabled = false,
				},
				floating = {
					max_height = nil, -- These can be integers or a float between 0 and 1.
					max_width = nil, -- Floats will be treated as percentage of your screen.
					border = "single", -- Border style. Can be "single", "double" or "rounded"
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				render = {
					max_type_length = nil, -- Can be integer or nil.
					max_value_lines = 100, -- Can be integer or nil.
				},
			})

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
}
