-- init.lua

vim.g.mapleader = "\\"

-- lazy.nvim
require("config.lazy")
-- plugins


local opt = vim.opt
local keymap = vim.keymap

opt.number = true
opt.relativenumber = true

opt.mouse = 'a'

opt.scrolloff = 0

opt.colorcolumn = '80,120'
opt.wrap = false
opt.textwidth = 120

opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.clipboard = 'unnamedplus'

opt.splitbelow = true

opt.wildmenu = true

opt.backspace = { 'indent', 'eol', 'start' }

opt.hidden = true

opt.swapfile = false

opt.formatoptions:append('j')

opt.list = false
opt.listchars = {
    tab = '▸ ',
    eol = '¬',
    space = '.',
    trail = '-',
    extends = '>',
    precedes = '<',
    nbsp = '+'
}
keymap.set('n', '<leader>l', '<cmd>set list!<CR>')

opt.foldenable = false

-- Cosmetics

if not vim.g.vscode then
opt.termguicolors = true
opt.background = 'dark'

vim.cmd.colorscheme('carbonfox')

-- highlight trailing whitespace
-- vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'red' })
-- vim.api.nvim_create_autocmd({ "WinEnter", "VimEnter" }, {
--     group = vim.api.nvim_create_augroup('TrailingSpace', { clear = true }),
--     pattern = "*",
--     callback = function()
--         vim.fn.matchadd('ExtraWhitespace', [[\s\+\%#\@<!$]])
--     end,
-- })

require('lualine').setup{
    options = {
        icons_enabled = false,
    }
}

end -- not vscode

-- Keymaps
keymap.set('i', 'jk', '<Esc>')

keymap.set('n', '<leader>\\', '<cmd>nohl<CR>')

-- keymap.set('n', '<leader>p', '<cmd>set paste!<CR>')

-- Disable Ex mode
keymap.set('n', 'Q', '<Nop>')

keymap.set('n', '<leader>r', '<cmd>set rnu!<CR>')

