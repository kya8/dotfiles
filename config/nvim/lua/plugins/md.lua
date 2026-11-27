return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    opts = {
        preview = { enable = false },
    },

    keys = {
        { "<leader>mp", "<cmd>Markview toggle<cr>", desc = "Toggle Markdown preview" },
        { "<leader>ms", "<cmd>Markview splitToggle<cr>", desc = "Toggle Markdown split preview" },
    }
};
