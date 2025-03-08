require("stefanaru.set")
require("stefanaru.remap")
require("stefanaru.lazy")
require("stefanaru.helpers.autosave")

local utils = require("stefanaru.utils")
local current_dir = vim.fn.expand("<sfile>:p:h")
utils.load_vimscript(current_dir .. "/lua/stefanaru/helpers/imports_folding.vim")

-- fix deprecations
vim.tbl_islist = vim.islist
