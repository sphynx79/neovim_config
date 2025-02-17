local M = {}

M.plugins = {
    ["windowswap"] = {
        "wesQ3/vim-windowswap",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["windowswap"] = function()
        vim.g.windowswap_map_keys = 0
        M.keybindings()
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "<localleader>ww",
            rhs = [[<Cmd>call WindowSwap#EasyWindowSwap()<CR>]],
            options = {silent = true },
            description = "Switch tra due finestre",
        },
        {
            mode = { "n"},
            lhs = "<localleader>yw",
            rhs = [[<Cmd>call WindowSwap#MarkWindowSwap()<CR>]],
            options = {silent = true },
            description = "Yank window",
        },
        {
            mode = { "n"},
            lhs = "<localleader>pw",
            rhs = [[<Cmd>call WindowSwap#MarkWindowSwap()<CR>]],
            options = {silent = true },
            description = "Paste window",
        },
    })
end

return M

