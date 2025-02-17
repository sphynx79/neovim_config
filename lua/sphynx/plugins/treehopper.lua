local M = {}

M.plugins = {
    ["treehopper"] = {
        "mfussenegger/nvim-treehopper",
        lazy = true,
        name = "treehopper"
    },
}

M.setup = {
    ["treehopper"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["treehopper"] = function()

    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "ì",
            rhs = [[<Cmd>lua require('tsht').nodes()<CR>]],
            options = {silent = true },
            description = "treesitter node selection",
        },
    })
end

return M

