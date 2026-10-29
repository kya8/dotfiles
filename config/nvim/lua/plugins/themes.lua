-- Overrides for nightfox
local groups = {
    carbonfox = {
        -- CursorLineNr = { fg = "#ff7829", style = "bold" }
        CursorLineNr = { fg = "#ed9ec8", style = "bold" }
    }
}

return {
    {
        "EdenEast/nightfox.nvim",
        cond = not vim.g.vscode,
        opts = {
            dim_inactive = true,
            groups = groups,
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        cond = not vim.g.vscode,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = false
                -- ,section_separators = '',
                -- component_separators = { left = '│', right = '│' }
            }
        }
    }
}

