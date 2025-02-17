local M = {}

M.plugins = {
    ["maximizer"] = {
        "eduardomillans/maximizer.nvim",
        lazy = true,
        keys = {"wM"},
        pin = true,
    },
}

M.configs = {
    ["maximizer"] = function()
        require("maximizer").setup({
            status = {
                enable = false, -- nil or false to disable
                text = "Maximizer is active!",
                blend = 10,
                position = {
                    top = true,
                    left = false,
                },
            },
            -- toggle keymap
            keymap = {
                enable = true, -- nil or false to disable
                modes = { "n" },
                rhs = "wM"
            }
        })
    end,
}

return M
