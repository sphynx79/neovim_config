local M = {}

M.plugins = {
    ["X"] = {
        "XY",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["X"] = function()

    end,
}

M.configs = {
    ["X"] = function()

    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "key",
            rhs = [[<Cmd>.....<CR>]],
            options = {silent = true },
            description = "Desc",
        },
    })
    require("which-key").register({
        x = {
            name = " Todo",
            q = {[[<Cmd>......<CR>]], "Desc"},
        },
    }, mapping.opt_plugin)
end

return M

