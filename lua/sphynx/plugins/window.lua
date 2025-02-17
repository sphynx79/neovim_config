local M = {}

M.plugins = {
    ["window"] = {
        "https://gitlab.com/yorickpeterse/nvim-window",
        name = "window",
        lazy = true,
    },
}

M.setup = {
    ["window"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["window"] = function()
        require('nvim-window').setup({
            -- The characters available for hinting windows.
            chars = {
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
            'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
            },

            -- A group to use for overwriting the Normal highlight group in the floating
            -- window. This can be used to change the background color.
            normal_hl = 'BlackOnLightYellow',

            -- The highlight group to apply to the line that contains the hint characters.
            -- This is used to make them stand out more.
            hint_hl = 'Bold',

            -- The border style to use for the floating window.
            border = 'none'
        })

        vim.cmd([[hi BlackOnLightYellow guifg=#000000 guibg=#82AAFF]])
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "ww",
            rhs = [[<Cmd>lua require('nvim-window').pick()<CR>]],
            options = {silent = true },
            description = "Switch window [nvim-window]",
        },
    })
end

return M

