local M = {}

M.plugins = {
    ["noice"] = {
        "folke/noice.nvim",
        version = "*",
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
}

M.setup = {
    ["noice"] = function()
        vim.g.lsp_handlers_enabled = false
    end,
}

M.configs = {
    ["noice"] = function()
        vim.opt.lazyredraw = false
        local enable_conceal = true          -- Hide command text if true

        local ignore_msg = function (kind, msg)
            return {
                opts = { skip = true },
                filter = {
                    event = "msg_show",
                    kind = kind,
                    find = msg,
                }
            }
        end

        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                progress = { enabled = false },
                signature = { enabled = true }, -- if used lspsaga or lsp_signature set disable
            },

            cmdline = {
                -- view = "cmdline_popup",                 -- The kind of popup used for :
                format= {
                    cmdline =     { conceal = enable_conceal, pattern = "^:", icon = "", lang = "vim" },
                    search_down = { conceal = enable_conceal, kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                    search_up =   { conceal = enable_conceal, kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                    filter =      { conceal = enable_conceal },
                    lua =         { conceal = enable_conceal, pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                    help =        { conceal = enable_conceal, pattern = "^:%s*he?l?p?%s+", icon = "󰋖"  },
                    input =       { conceal = enable_conceal },
                }
            },

            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },

            views = {
                -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#display-the-cmdline-and-popupmenu-together
                cmdline_popup = {
                    relative = "editor",
                    position = {
                        row = "50%",
                        col = "50%",
                    },
                    size = {
                        min_width = 80,
                        width = "auto",
                        height = "auto",
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = { row = 8, col = "50%" },
                    size = { width = 60, height = 10 },
                    border = { style = "rounded", padding = { 0, 1 } },
                    win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
                },
            },

            routes = {
                ignore_msg("search_count", nil), -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#hide-search-virtual-text
                ignore_msg("", "written"), -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#hide-written-messages-1
                ignore_msg("", "update"),
                ignore_msg("", "modifica"),
                ignore_msg("emsg", "E433: No tags file"),
                ignore_msg("emsg", "E486: Pattern not found"),
                ignore_msg("emsg", "E555: at bottom of tag stack"),
            },
        })
    end,
}

return M
