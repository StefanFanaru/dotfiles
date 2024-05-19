-- Sourced from here: https://github.com/nvim-telescope/telescope.nvim/issues/2014
-- Declare the module
local M = {}

-- Store Utilities we'll use frequently
local utils = require("telescope.utils")
local telescopeMakeEntryModule = require("telescope.make_entry")
local plenaryStrings = require("plenary.strings")
local devIcons = require("nvim-web-devicons")
local telescopeEntryDisplayModule = require("telescope.pickers.entry_display")
-- Obtain Filename icon width
-- --------------------------
-- INSIGHT: This width applies to all icons that represent a file type
local fileTypeIconWidth = plenaryStrings.strdisplaywidth(devIcons.get_icon("fname", { default = true }))

function M.get_path_and_tail(filename)
	local bufname_tail = utils.path_tail(filename)
	local path_without_tail = require("plenary.strings").truncate(filename, #filename - #bufname_tail, "")
	local path_to_display = utils.transform_path({
		path_display = { "truncate" },
	}, path_without_tail)

	return bufname_tail, path_to_display
end
---- Picker functions ----
function M.get_pretty_file_options()
	options = {}

	--- //////// item stylish.
	local entry_make = telescopeMakeEntryModule.gen_from_file(options)
	options.entry_maker = function(line)
		local entry = entry_make(line)
		local displayer = telescopeEntryDisplayModule.create({
			separator = " ",
			items = {
				{ width = fileTypeIconWidth },
				{ width = nil },
				{ remaining = true },
			},
		})
		entry.display = function(et)
			-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/make_entry.lua
			local tail_raw, path_to_display = M.get_path_and_tail(et.value)
			local tail = tail_raw .. " "
			local icon, iconhl = utils.get_devicons(tail_raw)

			return displayer({
				{ icon, iconhl },
				tail,
				{ path_to_display, "TelescopeResultsComment" },
			})
		end
		return entry
	end
	return options
end
-- Generates a Find File picker but beautified
function M.prettyFilesPicker(user_opts)
	user_opts = user_opts or {}
	---/// end item stylish
	local options = M.get_pretty_file_options()
	for k, v in pairs(user_opts) do
		options[k] = v
	end
	require("telescope.builtin").find_files(options)
end

function M.prettyGrepPicker()
	options = {}

	local originalEntryMaker = telescopeMakeEntryModule.gen_from_vimgrep(options)

	options.entry_maker = function(line)
		local originalEntryTable = originalEntryMaker(line)

		local displayer = telescopeEntryDisplayModule.create({
			separator = " ", -- Telescope will use this separator between each entry item
			items = {
				{ width = fileTypeIconWidth },
				{ width = nil },
				{ width = nil }, -- Maximum path size, keep it short
				{ remaining = true },
			},
		})

		originalEntryTable.display = function(entry)
			local tail, pathToDisplay = M.get_path_and_tail(entry.filename)

			local icon, iconHighlight = utils.get_devicons(tail)

			local tailForDisplay = tail .. " "

			local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, "utf8") or entry.text

			return displayer({
				{ icon, iconHighlight },
				tailForDisplay,
				{ pathToDisplay, "TelescopeResultsComment" },
				text,
			})
		end

		return originalEntryTable
	end

	require("telescope.builtin").live_grep(options)
end

return M
