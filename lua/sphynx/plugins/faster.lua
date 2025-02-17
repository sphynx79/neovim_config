local M = {}

M.plugins = {
    ["faster"] = {
        "PHSix/faster.nvim",
        lazy = true,
        name = "faster",
    },
}

M.setup = {
    ["faster"] = function()
        M.keybindings()
    end
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "<down>",
            rhs = [[<Cmd>lua require('faster').move("j")<CR>]],
            options = {noremap=false, silent = true },
            description = "Move cursor down fast",
        },
        {
            mode = { "n"},
            lhs = "<up>",
            rhs = [[<Cmd>lua require('faster').move("k")<CR>]],
            options = {noremap=false, silent = true },
            description = "Move cursor up fast",
        },
    })
end

return M

