local map = require("stefanaru.utils").mapkey
return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			local trouble = require("trouble")
			map("n", "]t", function()
				trouble.next({ skip_groups = true, jump = true })
			end, "Next Trouble")
			map("n", "[t", function()
				trouble.previous({ skip_groups = true, jump = true })
			end, "Previous Trouble")
			map("n", "<leader>xx", function()
				trouble.toggle()
			end, "Toggle Trouble")
			map("n", "<leader>xw", function()
				trouble.toggle("workspace_diagnostics")
			end, "Toggle Workspace Diagnostics")
			map("n", "<leader>xd", function()
				trouble.toggle("document_diagnostics")
			end, "Toggle Document Diagnostics")
			map("n", "<leader>xq", function()
				trouble.toggle("quickfix")
			end, "Toggle Quickfix")
			map("n", "<leader>xl", function()
				trouble.toggle("loclist")
			end, "Toggle Loclist")
			map("n", "<leader>xr", function()
				trouble.refresh()
			end, "Refresh Trouble")
			map("n", "gR", function()
				trouble.toggle("lsp_references")
			end, "Toggle LSP References")
		end,
	},
}
