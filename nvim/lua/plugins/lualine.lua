local colors = {
	color2 = "#161821",
	color3 = "#b4be82",
	color4 = "#c6c8d1",
	color5 = "#2e313f",
	color8 = "#e2a478",
	color9 = "#3e445e",
	color10 = "#21201e",
	color11 = "#17171b",
	color12 = "#818596",
	color15 = "#64b36c",
}

local custom_iceberg_dark = {
	visual = {
		a = { fg = colors.color2, bg = colors.color3, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
	replace = {
		a = { fg = colors.color2, bg = colors.color8, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
	inactive = {
		a = { fg = colors.color9, bg = colors.color10, gui = "bold" },
		b = { fg = colors.color9, bg = colors.color10 },
		c = { fg = colors.color9, bg = colors.color10 },
	},
	normal = {
		a = { fg = colors.color11, bg = colors.color12, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
		c = { fg = colors.color4, bg = colors.color10 },
	},
	insert = {
		a = { fg = colors.color2, bg = colors.color15, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = custom_iceberg_dark,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "filetype" },
				lualine_y = { "diff" },
				lualine_z = { "branch" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
