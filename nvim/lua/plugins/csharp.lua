return {
	{
		dir = "~/personal/csharp.nvim",
		ft = "cs",
		config = function()
			require("mason").setup() -- Mason setup must run before csharp
			require("csharp").setup()
		end,
	},

	{
		dir = "~/personal/roslyn.nvim",
		ft = "cs",
	},
}
