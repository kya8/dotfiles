return {
    {
        'nvim-telescope/telescope.nvim', version = '*',
        cond = not vim.g.vscode,
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            },
        },

        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search text" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Search word under cursor" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },
            { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
            {
                "<leader>fF",
                function()
                    vim.ui.input({
                        prompt = "Search directory: ",
                        default = vim.fn.getcwd() .. "/",
                        completion = "dir",
                    }, function(dir)
                        if dir and dir ~= "" then
                            require("telescope.builtin").find_files({ cwd = dir })
                        end
                    end)
                end,
                desc = "Find files in directory",
            },
            {
                "<leader>fc",
                function()
                    require("telescope.builtin").find_files({
                        cwd = vim.fn.expand("%:p:h"),
                    })
                end,
                desc = "Find files near current buffer",
            },
        },
        opts = {
            defaults = {
                sorting_strategy = "ascending",
                layout_strategy = "flex",
                layout_config = {
                    prompt_position = "top",
                    width = 0.90,
                    height = 0.85,
                    horizontal = {
                        preview_width = 0.55,
                    },
                    vertical = {
                        preview_height = 0.55,
                    },
                    flex = {
                        flip_columns = 120,
                    },
                },

                path_display = { "truncate" },

                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
            },

            pickers = {
                find_files = {
                    find_command = function()
                        return { "rg", "--files", "--hidden", "--glob", "!.git" }
                    end,
                },
                live_grep = {
                    additional_args = function()
                        return { "--hidden", "--glob", "!.git" }
                    end,
                },
                grep_string = {
                    additional_args = function()
                        return { "--hidden", "--glob", "!.git" }
                    end,
                },
                buffers = {
                    sort_mru = true,
                    mappings = {
                        i = {
                            ["<C-d>"] = "delete_buffer",
                        },
                        n = {
                            ["dd"] = "delete_buffer",
                        },
                    },
                },
            },
        },

        config = function(_, opts)
            local ts = require("telescope")
            ts.setup(opts)
            ts.load_extension("fzf")
        end,
    }
}
