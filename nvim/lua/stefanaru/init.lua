require("stefanaru.set")
require("stefanaru.remap")
require("stefanaru.lazy")
require("stefanaru.utils")
require("stefanaru.helpers.autosave")


local function load_vimscript(filename)
    local escaped_filename = vim.fn.fnameescape(filename)
    vim.cmd('source ' .. escaped_filename)
end

-- Specify the path to your .vim file
local vimscript_file = '/home/stefanaru/dotfiles/nvim/lua/stefanaru/helpers/imports_folding.vim'

-- Load the Vimscript file
load_vimscript(vimscript_file)
