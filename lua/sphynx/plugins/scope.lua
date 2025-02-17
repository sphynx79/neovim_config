-- NOTE:: Per funzionare devo usare il comand tcd C:\dir.... per avere la working directory relativa al tab

local M = {}

M.plugins = {
    ["scope"] = {
        "tiagovla/scope.nvim",
        lazy = true,
        name = "scope",
        event = "VeryLazy",
    },
}

M.configs = {
    ["scope"] = function()
        require("scope").setup {}
    end,
}

return M

