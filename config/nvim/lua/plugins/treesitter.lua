return {
    {
        'nvim-treesitter/nvim-treesitter',
        cond = not vim.g.vscode,
        lazy = false,
        build = ':TSUpdate',
        config = function()
            local ts = require('nvim-treesitter')
            ts.setup({

            })

            ts.install({
                'c', 'cpp', 'cmake', 'rust',
                'lua', 'python', 'bash', 'zsh',
                'json', 'yaml', 'toml', 'html', 'css',
                'markdown', 'markdown_inline',
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang or not vim.treesitter.language.add(lang) then return end
                    if vim.treesitter.query.get(lang, "highlights") then vim.treesitter.start(args.buf) end
                    -- if vim.treesitter.query.get(lang, "indents") then
                    --     vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
                    -- end
                    if vim.treesitter.query.get(lang, "folds") then
                        vim.wo[0][0].foldmethod = "expr"
                        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    end
                end,
            })
        end,
    }
}
