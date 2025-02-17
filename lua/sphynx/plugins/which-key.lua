local M = {}

M.plugins = {
    ["which_key"] = {
        "folke/which-key.nvim",
        lazy = true,
    },
}

M.configs = {
    ["which_key"] = function()
        require('which-key').setup {
            preset = "classic",
            debug = false,
            -- show a warning when issues were detected with your mappings
            notify = true,
            delay = function(ctx)
                return ctx.plugin and 0 or 800
            end,
            filter = function(mapping)
                -- example to exclude mappings without a description
                -- -- return mapping.desc and mapping.desc ~= ""
                return mapping.desc ~= ""
            end,
            triggers = {
                { "<auto>", mode = "nxsot" },
                --{ "<leader>", mode = "nxsotv" },
                { "w", mode = "n" },
                { "b", mode = "n" },
                { "t", mode = "n" },
                { "e", mode = "n" },
                { "m", mode = "n" },
            },
            plugins = {
                marks = false, -- shows a list of your marks on ' and `
                registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
                spelling = {
                    enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                    suggestions = 20, -- how many suggestions should be shown in the list?
                },
                presets = {
                    operators = false, -- adds help for operators like d, y, ...
                    motions = false, -- adds help for motions
                    text_objects = false, -- help for text objects triggered after entering an operator
                    windows = false, -- default bindings on <c-w>
                    nav = false, -- misc bindings to work with windows
                    z = false, -- bindings for folds, spelling and others prefixed with z
                    g = false, -- bindings for prefixed with g
                },
            },
            win = {
                row = -1,
                border = "single",
                padding = { 1, 2 },
            },
            layout = {
                width = { min = 20 }, -- min and max width of the columns
                spacing = 4,          -- spacing between columns
                align = "center",     -- align columns left, center or right
            },
            icons = {
                breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                separator = "", -- symbol used between a key and it's label
                group = "+", -- symbol prepended to a group
                ellipsis = "…",
                mappings = false,
            },
            disable = {
                bt = {},
                ft = { "TelescopePrompt" },
            },

        }
    end,
}

return M

