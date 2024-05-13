return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, desc, opts)
				opts = opts or {}
				opts.buffer = bufnr
				opts.desc = desc
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)

			-- Actions
			map("n", "<leader>hs", gitsigns.stage_hunk, "Git stage hunk")
			map("n", "<leader>hr", gitsigns.reset_hunk, "Git reset hunk")
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Git stage hunk")
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Git reset hunk")
			map("n", "<leader>hS", gitsigns.stage_buffer, "Git stage buffer")
			map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Git undo stage hunk")
			map("n", "<leader>hR", gitsigns.reset_buffer, "Git reset buffer")
			map("n", "<leader>hp", gitsigns.preview_hunk, "Git preview hunk")
			map("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, "Git blame line")
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Git toggle line blame")
			map("n", "<leader>hd", gitsigns.diffthis, "Git diff this")
			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, "Git diff this on HEAD")
			map("n", "<leader>td", gitsigns.toggle_deleted, "Git toggle deleted")

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	},
}
