local M = {}

M.plugins = {
    ["sorround"] = {
        "kylechui/nvim-surround",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["sorround"] = function()
        require("nvim-surround").setup()
    end,
}

return M

