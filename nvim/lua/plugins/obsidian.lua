local obsidian = {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	cmd = { "ObsidianNew", "ObsidianSearch", "ObsidianQuickSearch" },
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
		-- Put new notes in the New directory, also use title instead of id when given
		note_path_func = function(spec)
			-- This is equivalent to the default behavior.
			local note_title = ""
			if spec.title and spec.title ~= "" then
				note_title = spec.title
			else
				note_title = "new-" .. spec.id
			end
			local file_name = note_title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			local path = spec.dir / file_name
			return path:with_suffix(".md")
		end,
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
		disable_frontmatter = true,
		templates = {
			folder = "Resources/Assets/Templates",
			date_format = "%d %b %H:%M",
			time_format = "%H:%M",
		},
		attachments = {
			img_folder = "Resources/Assets",
		},
	},
}

-- NOTE: Key maps configuration
local utils = require("stefanaru.utils")
local map = utils.mapkey

-- Define a function to prompt for input and execute the command
function ObsidianNewWithTitle()
	-- Save the current input prompt
	vim.fn.inputsave()

	local success, title = pcall(function()
		-- Take the input for the title
		return vim.fn.input("Title: ")
	end)

	-- Restore the previous input prompt
	vim.fn.inputrestore()

	if not success then
		-- Handle the keyboard interrupt here
		return
	end

	if title == "" then
		-- If no title provided, set a default title
		title = "new-note-" .. string.sub(utils.generate_guid(), 1, 8)
	end

	-- Execute the command with the provided title
	vim.cmd("ObsidianNew " .. title)
end

function ObsidianNewImage()
	local title = utils.generate_guid()
	vim.cmd("ObsidianPasteImg " .. title .. "<CR>")
end

map("n", "<leader>on", ":lua ObsidianNewWithTitle()<CR>", "New note")
map("n", "<leader>oi", ":lua ObsidianNewImage()<CR>", "Paste image")
map("n", "<leader>os", "<cmd>ObsidianQuickSearch<CR>", "Open notes")
map("n", "<leader>og", "<cmd>ObsidianSearch<CR>", "Search notes")
map("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", "Open note in app")
map("n", "<leader>ot", "<cmd>ObsidianToggleCheckbox<CR>", "Toggle checkbox")

return obsidian
