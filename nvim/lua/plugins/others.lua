return {
	{ "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
	{ "tpope/vim-unimpaired", event = { "BufReadPost", "BufNewFile" } },
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
	{
		"nvim-pack/nvim-spectre",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("spectre").setup({
				replace_engine = {
					["sed"] = {
						cmd = "sed",
						args = {
							"-i",
							"",
							"-E",
						},
					},
				},
			})
			vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
		end,
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"Wansmer/treesj",
		keys = { "<space>bb" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({ use_default_keymaps = false })
			vim.keymap.set("n", "<leader>bb", require("treesj").toggle, { desc = "Toggle treesj (split / join)" })
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false, keywords = { TODO = { alt = { "todo" } } } },
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
	{
		"b0o/SchemaStore.nvim",
		version = false, -- last release is way too old
	},
	{ "folke/neodev.nvim", opts = {} },
	-- { "subnut/nvim-ghost.nvim" },
	-- {
	-- 	"glacambre/firenvim",
	--
	-- 	-- Lazy load firenvim
	-- 	-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
	-- 	lazy = not vim.g.started_by_firenvim,
	-- 	build = function()
	-- 		vim.fn["firenvim#install"](0)
	-- 	end,
	-- },
	--
	{
		"realprogrammersusevim/md-to-html.nvim",
		cmd = { "MarkdownToHTML", "NewMarkdownToHTML" },
	},
	{
		"Equilibris/nx.nvim",

		dependencies = {
			"nvim-telescope/telescope.nvim",
		},

		opts = {
			-- See below for config options
			nx_cmd_root = "npx nx",
		},

		-- Plugin will load when you use these keys
		keys = {
			{ "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
		},
	},
	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	-- 	opts = {},
	-- },
}
