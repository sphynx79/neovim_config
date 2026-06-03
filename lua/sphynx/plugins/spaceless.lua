local M = {}

M.plugins = {
    ["spaceless"] = {
        "lewis6991/spaceless.nvim",
        lazy = true,
        name = "spaceless",
    },
}

M.setup = {
    ["spaceless"] = function()
        require("sphynx.utils.lazy_load").on_file_open("spaceless")
    end,
}

return M
