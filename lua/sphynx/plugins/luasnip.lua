local luasnip = {}

luasnip.plugins = {
    ["luasnip"] = {
        "L3MON4D3/LuaSnip",
        lazy = true,
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        -- event = {"InsertEnter", "CmdlineEnter"},
    },
}


luasnip.configs = {
    ["luasnip"] = function()
        local types = require("luasnip.util.types")
        require("luasnip").config.set_config {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "choiceNode", "WildMenu" } },
                    },
                },
            },
            }

            -- local path = sphynx.config.code_snippets_directory
            -- TODO: vedere se risco a caricarli in modalità lazy
            -- local path = vim.fn.expand(vim.fn.stdpath("data") .. "/snippet")
            -- require("luasnip.loaders.from_vscode").load({ paths = { path } })
            require("sphynx.plugins.snippets")
    end,
}

return luasnip
