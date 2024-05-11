return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = {
		"BufReadPre /mnt/f/obsidian/stefanaru-second-brain/**.md",
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
	},
}
