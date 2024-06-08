require("stefanaru.set")
require("stefanaru.remap")
require("stefanaru.lazy")
require("stefanaru.helpers.autosave")

local utils = require("stefanaru.utils")
utils.load_vimscript("/home/stefanaru/dotfiles/nvim/lua/stefanaru/helpers/imports_folding.vim")

-- fix deprecations
vim.tbl_islist = vim.islist
