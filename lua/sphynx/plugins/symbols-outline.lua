local M = {}

M.plugins = {
    ["symbols_outline"] = {
        "simrat39/symbols-outline.nvim",
        lazy = true,
        cmd = { "SymbolsOutline" },
    },
}

M.setup = {
    ["symbols_outline"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["symbols_outline"] = function()
        vim.g.symbols_outline = {
            highlight_hovered_item = true,
            show_guides = true,
            auto_preview = true,
            position = "right",
            width = 25,
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            preview_bg_highlight = "Pmenu",
            keymaps = { -- These keymaps can be a string or a table for multiple keys
                close = { "<Esc>", "q" },
                goto_location = "<Cr>",
                focus_location = "o",
                hover_symbol = "<C-space>",
                toggle_preview = "K",
                rename_symbol = "r",
                code_actions = "a",
            },
            lsp_blacklist = {},
            symbol_blacklist = {},
            symbols = {
                File = { icon = "󰈔", hl = "TSURI" },
                Module = { icon = "󰆧", hl = "TSNamespace" },
                Namespace = { icon = "󰅪", hl = "TSNamespace" },
                Package = { icon = "󰏗", hl = "TSNamespace" },
                Class = { icon = "𝓒", hl = "TSType" },
                Method = { icon = "ƒ", hl = "TSMethod" },
                Property = { icon = "󰜢", hl = "TSMethod" },
                Field = { icon = "󰆨", hl = "TSField" },
                Constructor = { icon = "", hl = "TSConstructor" },
                Enum = { icon = "ℰ", hl = "TSType" },
                Interface = { icon = "󰜰", hl = "TSType" },
                Function = { icon = "", hl = "TSFunction" },
                Variable = { icon = "", hl = "TSConstant" },
                Constant = { icon = "", hl = "TSConstant" },
                String = { icon = "𝓐", hl = "TSString" },
                Number = { icon = "#", hl = "TSNumber" },
                Boolean = { icon = "⊨", hl = "TSBoolean" },
                Array = { icon = "󰅪", hl = "TSConstant" },
                Object = { icon = "⦿", hl = "TSType" },
                Key = { icon = "🔐", hl = "TSType" },
                Null = { icon = "NULL", hl = "TSType" },
                EnumMember = { icon = "", hl = "TSField" },
                Struct = { icon = "𝓢", hl = "TSType" },
                Event = { icon = "🗲", hl = "TSType" },
                Operator = { icon = "󰆕", hl = "TSOperator" },
                TypeParameter = { icon = "𝙏", hl = "TSParameter" },
            },
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n" },
            lhs = "<F7>",
            rhs = [[<Cmd>SymbolsOutline<CR>]],
            options = { silent = true },
            description = "Open vista Tag-LSP list",
        },
    })
    require("which-key").register({
        p = {
            name = "󰏗 Plugin",
            s = {
                function()
                    require("lazy").load({ plugins = { "symbols-outline.nvim" } })
                    vim.cmd([[SymbolsOutline]])
                end,
                "Symbols_outline",
            },
        },
    }, mapping.opt_plugin)
end

return M
