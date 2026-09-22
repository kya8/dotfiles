return {
    {
        "EdenEast/nightfox.nvim",
        cond = not vim.g.vscode,
        opts = {
            dim_inactive = true,
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        cond = not vim.g.vscode,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    }
}

