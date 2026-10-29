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
opt.wrapscan = false

-- opt.clipboard = 'unnamedplus'
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

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

opt.shell = "zsh"

-- Keymaps
keymap.set('i', 'jk', '<Esc>')

keymap.set('n', '<leader>\\', '<cmd>nohl<CR>')
keymap.set('n', '<leader>w', '<cmd>set wrap!<CR>')

-- keymap.set('n', '<leader>p', '<cmd>set paste!<CR>')

-- Disable Ex mode
keymap.set('n', 'Q', '<Nop>')

keymap.set('n', '<leader>r', '<cmd>set rnu!<CR>')


-- Outside vscode-neovim
if not vim.g.vscode then

-- Cosmetics
opt.termguicolors = true
opt.background = 'dark'

vim.cmd.colorscheme('carbonfox')

require('lualine').setup{
    options = {
        icons_enabled = false
        -- ,section_separators = '',
        -- component_separators = { left = '│', right = '│' }
    }
}

opt.scrolloff = 3
opt.sidescrolloff = 8

opt.cursorline = true
opt.cursorlineopt = "number"
--[[
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.cursorlineopt = "number"
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.opt_local.cursorlineopt = "both"
  end,
})

keymap.set('n', '<leader>c', '<cmd>set cursorline!<CR>')
--]]

end -- Not vscode-neovim

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    -- Use vim.highlight.on_yank() if on Neovim < 0.11
    vim.hl.on_yank({
      higroup = "IncSearch", -- Highlight group to use (default: "IncSearch")
      timeout = 130,         -- Duration in milliseconds (default: 150)
      on_visual = true,      -- Highlight when yanking from visual mode (default: true)
      on_macro = false,      -- Highlight when executing macros (default: false)
    })
  end,
})
