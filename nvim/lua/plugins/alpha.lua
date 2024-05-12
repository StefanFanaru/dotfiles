local M = {}

function M.btn_gen(label, shortcut, hl_label, hl_icon)
	return {
		type = "button",
		on_press = function()
			local key = api.nvim_replace_termcodes(shortcut:gsub("%s", ""):gsub("LDR", "<leader>"), true, false, true)
			api.nvim_feedkeys(key, "normal", false)
		end,
		val = label,
		opts = {
			position = "center",
			shortcut = shortcut,
			cursor = 5,
			width = 25,
			align_shortcut = "right",
			hl_shortcut = "AlphaKeyPrefix",
			hl = {
				{ hl_icon, 1, 3 }, -- highlight the icon glyph
				{ hl_label, 4, 15 }, -- highlight the part after the icon glyph
			},
		},
	}
end

return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local startify = require("alpha.themes.startify")

		local nvim_version = vim.split(vim.fn.execute("version"), "\n")[3]:sub(6)

		startify.section.header.val = {
			" _ __    ___   ___ __   __ _  _ __ ___  ",
			"|  _ \\  / _ \\ / _ \\  \\ / /| ||  _   _ \\ ",
			"| | | ||  __/| (_) |\\ V / | || | | | | |",
			"|_| |_| \\___| \\___/  \\_/  |_||_| |_| |_|",
			"       " .. nvim_version .. "            ",
		}

		vim.cmd("highlight AlphaNeoVimLogo guifg=#89b4fa guibg=NONE gui=NONE")

		startify.section.header.opts = {
			hl = "AlphaNeoVimLogo",
		}

		require("alpha").setup(require("alpha.themes.startify").config)
	end,
}
