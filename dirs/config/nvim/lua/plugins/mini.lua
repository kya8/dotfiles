return {
    {
        'nvim-mini/mini.nvim',
        version = '*',
        config = function()
            require("mini.surround").setup()
            if not vim.g.vscode then
                require("mini.trailspace").setup()
            end
        end,
    },
}
