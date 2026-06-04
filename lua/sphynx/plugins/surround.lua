local M = {}

M.plugins = {
    ["surround"] = {
        "kylechui/nvim-surround",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["surround"] = function()
        require("nvim-surround").setup()
    end,
}

return M
