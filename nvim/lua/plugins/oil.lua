return {
	"stevearc/oil.nvim",
	opts = {
		delete_to_trash = true,
		git = {
			add = function(path)
				return true
			end,
			mv = function(src_path, dest_path)
				return true
			end,
			rm = function(path)
				return false
			end,
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
