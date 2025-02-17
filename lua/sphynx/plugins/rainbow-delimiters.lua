local M = {}

M.plugins = {
    ["rainbow-delimiters"] = {
        "HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
    },
}

M.configs = {
    ["rainbow-delimiters"] = function()
        local rainbow_delimiters = require 'rainbow-delimiters'
        require 'rainbow-delimiters.setup'.setup {
            strategy = {
                [''] = rainbow_delimiters.strategy['global'],
                vim = rainbow_delimiters.strategy['local'],
            },
            query = {
                [''] = 'rainbow-delimiters',
                latex = 'rainbow-blocks',
                lua = 'rainbow-blocks',
                typescript = "rainbow-parens",
                javascript = "rainbow-parens",
                javascriptreact = "rainbow-parens",
                tsx = "rainbow-parens",
                jsx = "rainbow-parens",
                html = "rainbow-parens",
            },
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterGreen',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            },
            blacklist = {'help'},
        }
    end,
}

return M
