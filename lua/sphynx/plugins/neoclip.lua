local M = {}

M.plugins = {
    ["neoclip"] = {
        "AckslD/nvim-neoclip.lua",
        -- disable = true,
        lazy = true,
        event = {"TextYankPost"},
    },
}

M.configs = {
    ["neoclip"] = function()
        require('neoclip').setup({
            history = 50,
            enable_persistent_history = false,
            db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
            filter = nil,
            preview = true,
            default_register = '"',
            content_spec_column = false,
            on_paste = {set_reg = false},
            keys = {
            telescope = {
                i = {
                    select = '<cr>',
                    paste = '<c-p>',
                    paste_behind = '<c-k>',
                    replay = '<c-q>',
                    delete = '<c-d>',
                    edit = '<c-e>',
                    custom = {},
                },
                n = {
                    select = '<cr>',
                    paste = 'p',
                    paste_behind = 'P',
                    replay = 'q',
                    delete = 'd',
                    edit = 'e',
                    custom = {},
                },
            },
            }
        })
        require('telescope').load_extension('neoclip')

    end,
}

return M

