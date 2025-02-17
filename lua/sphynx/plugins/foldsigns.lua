local M = {}

M.plugins = {
    ["foldsigns"] = {
        "lewis6991/foldsigns.nvim",
        lazy = true,
        name = "foldsigns",
    },
}

M.setup = {
    ["foldsigns"] = function()
        require("sphynx.utils.lazy_load").on_file_open "foldsigns"
    end,
}

M.configs = {
    ["foldsigns"] = function()
        require('foldsigns').setup()
    end,
}

return M

