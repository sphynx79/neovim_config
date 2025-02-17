local M = {}

M.plugins = {
    ["neodev"] = {
        "folke/neodev.nvim",
        lazy = true,
        opts = { experimental = { pathStrict = true } }
    },
}

return M
