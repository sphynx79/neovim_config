local M = {}

M.plugins = {
    ["pretty_fold"] = {
        "anuvyklack/pretty-fold.nvim",
		pin= true,
        lazy = true,
    },
}

M.setup = {
    ["pretty_fold"] = function()
        require("sphynx.utils.lazy_load").on_file_open "pretty-fold.nvim"
    end,
}

M.configs = {
    ["pretty_fold"] = function()
        require('pretty-fold').setup{
            fill_char = '─',
            sections = {
                left = {
                    'content',
                },
                right = {
                    '┼ ', 'number_of_folded_lines', ': ', 'percentage', ' ┤',
                }
            },
            ft_ignore = { 'neorg' },
        }
    end,
}

return M

