--[[
===============================================================================================
Plugin: folke/noice.nvim
===============================================================================================
Description: Rimpiazza completamente la UI di Neovim per messaggi (`messages`), riga di comando
             (`cmdline`) e menu di completamento (`popupmenu`), usando viste configurabili
             (popup, split, notify, mini, virtualtext). Notifiche e messaggi vengono instradati
             a viste diverse tramite filtri/route.
Status: Active
Author: Sphynx (configurazione) / folke (plugin)
Repository: https://github.com/folke/noice.nvim
Dependencies: MunifTanjim/nui.nvim (rendering viste), rcarriga/nvim-notify (vista notify)
Notes:
 - Schema di config PIATTO: `cmdline`, `messages`, `popupmenu`, `redirect`, `lsp`, `views`,
   `routes` sono chiavi TOP-LEVEL (fratelli). Le chiavi messe nel nodo sbagliato vengono
   ignorate silenziosamente da noice (nessun errore) → attenzione all'annidamento.
 - Notifiche e messaggi nativi di Vim sono instradati alla vista `notify` (nvim-notify), che è
   il default: appaiono come toast in alto a destra. La funzione globale `vim.notify` è
   impostata su nvim-notify all'inizio di M.configs.
 - `lazyredraw = false`: forzato perché `lazyredraw` è incompatibile con noice.
 - `lsp.override`: la resa markdown dei documenti LSP (hover/signature) passa per Treesitter.
 - `lsp.progress`: avanzamento LSP mostrato nella vista custom `lsp-view` (in alto a destra).
 - `lsp.signature` disabilitata; `lsp.hover` abilitato (max 170x120).
 - `cmdline`: popup centrale (`cmdline_popup`) con icone e syntax highlight per : / ricerca /
   lua / shell / help; conceal del testo cmdline attivo.
 - `presets`: `bottom_search` (ricerca classica in basso) e `long_message_to_split` attivi.
 - `routes`: filtri con `skip = true` per nascondere messaggi rumorosi (scrittura/lettura file,
   conteggio ricerche, "pattern not found", tag mancanti, righe modificate, ecc.).
===============================================================================================
--]]

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
        vim.notify = require("notify")
        local enable_conceal = true -- Hide command text if true

        if pcall(require, "telescope") then
            require("telescope").load_extension("noice")
        end

        local ignore_msg = function(kind, msg)
            return {
                opts = { skip = true },
                filter = {
                    event = "msg_show",
                    kind = kind,
                    find = msg,
                },
            }
        end

        local filterReadMsg = {
            event = "msg_show",
            kind = "",
            any = {
                { find = '^".+"  ?%d+ lines? %-%-%d+%%%-%-$' },
                { find = '^".+"  ?%[.+%] %d+ lines? %-%-%d+%%%-%-$' },
                { find = '^".+"  ?%d+L, %d+B$' },
                { find = '^".+"  ?%[.+%] %d+L, %d+B$' },
            },
        }

        local filterLineChanged = {
            event = "msg_show",
            any = {
                { find = ".+[；;] ?before #[0-9]+  .+" },
                { find = ".+[；;] ?after #[0-9]+  .+" },
                { find = "^少了 [0-9]+ 行$" },
                { find = "^[0-9]+ fewer lines$" },
                { find = "^1 line less$" },
                { find = "^[0-9]+ line [><]ed [0-9]+ time" },
            },
        }

        local filterNoLinesInBuf = {
            event = "msg_show",
            kind = "",
            any = { { find = "%-%No lines in buffer%-%-$" }, { find = "%-%-缓冲区无内容%-%-$" } },
        }

        local filterSearch = { event = "msg_show", kind = "", max_height = 1, find = "^[/?].+" }
        local filterSearchCount = { event = "msg_show", kind = "search_count" }

        local routes = {

            { -- Hide diagnostics messages
                filter = { event = "lsp", find = " diagnostics_on_open " },
                opts = { skip = true },
            },

            -- Hide read messages
            { filter = filterReadMsg, opts = { skip = true } },

            { -- Hide Search
                filter = filterSearchCount,
                opts = { skip = true },
            },

            { -- Hide Search
                filter = filterSearch,
                opts = { skip = true },
            },

            { -- Hide messages "--No lines in buffer--" or "--缓冲区无内容--"
                filter = filterNoLinesInBuf,
                opts = { skip = true },
            },

            { -- Hide lines changed/removed/moved
                filter = filterLineChanged,
                opts = { skip = true },
            },

            {
                filter = { event = "msg_show", find = "lsp_signature? handler RPC" },
                opts = { skip = true },
            },

            ignore_msg("search_count", nil),
            ignore_msg("", "written"),
            ignore_msg("", "update"),
            ignore_msg("", "modifica"),
            ignore_msg("emsg", "E433: No tags file"),
            ignore_msg("emsg", "E486: Pattern not found"),
            ignore_msg("emsg", "E555: at bottom of tag stack"),
        }

        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    -- Da Abilitare se uso cmp
                    -- ["cmp.entry.get_documentation"] = true,
                },
                progress = {
                    enabled = true,
                    -- view = "mini", -- oppure "notify", "compact", "virtualtext"
                    view = "lsp-view",
                    throttle = 1000 / 30,
                },
                signature = { enabled = false }, -- if used lspsaga or lsp_signature set disable
                hover = {
                    enabled = true,
                    opts = {
                        size = {
                            max_width = 170,
                            max_height = 120,
                        },
                    },
                },
            },

            markdown = {
                hover = {
                    ["|(%S-)|"] = vim.cmd.help, -- vim help links
                    ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
                },

                highlights = {
                    ["|%S-|"] = "@text.reference",
                    ["@%S+"] = "@parameter",
                    ["^%s*(Parameters:)"] = "@text.title",
                    ["^%s*(Return:)"] = "@text.title",
                    ["^%s*(See also:)"] = "@text.title",
                    ["{%S-}"] = "@parameter",
                },
            },

            health = {
                checker = false, -- Disable if you don't want health checks to run
            },

            cmdline = {
                view = "cmdline_popup", -- The kind of popup used for :
                -- view = "cmdline",    -- The kind of popup used for :
                enabled = true, -- enables the Noice cmdline UI
                view_search = false, -- view for search count messages. Set to `false` to disable
                -- view = 'cmdline_popup',
                format = {
                    cmdline = { conceal = enable_conceal, pattern = "^:", icon = ">", lang = "vim" },
                    search_down = {
                        conceal = enable_conceal,
                        kind = "search",
                        pattern = "^/",
                        icon = " ",
                        lang = "regex",
                    },
                    search_up = {
                        conceal = enable_conceal,
                        kind = "search",
                        pattern = "^%?",
                        icon = " ",
                        lang = "regex",
                    },
                    filter = { conceal = enable_conceal, pattern = "^:%s*!", icon = "", lang = "bash" },
                    man = { pattern = "^:%s*Man%s+", icon = "󰗚", lang = "bash" },
                    lua = {
                        conceal = enable_conceal,
                        pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                        icon = "",
                        lang = "lua",
                    },
                    help = { conceal = enable_conceal, pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
                    input = { conceal = enable_conceal },
                },
            },

            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = false, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
            },

            views = {
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
                        -- style = "rounded",
                        style = sphynx.config.border_style,
                        padding = { 0, 0 },
                    },
                    win_options = {
                        winblend = 6,
                        winhighlight = {
                            Normal = "NoiceCmdlinePopup",
                            FloatBorder = "NoiceCmdlinePopupBorder",
                            FloatTitle = "NoiceCmdlinePopupTitle",
                        },
                    },
                },
                cmdline_popupmenu = {
                    view = "popupmenu",
                    zindex = 200,
                },
                popupmenu = {
                    relative = "editor",
                    enabled = true,
                    backend = "nui",
                    position = { row = 8, col = "50%" },
                    size = { width = 60, height = 10 },
                    border = { style = "rounded", padding = { 0, 1 } },
                    win_options = {
                        winblend = 60,
                        winhighlight = {
                            Normal = "NoicePopupmenu",
                            FloatBorder = "NoicePopupmenuBorder",
                            CursorLine = "NoicePopupmenuSelected",
                            PmenuMatch = "NoicePopupmenuMatch",
                        },
                    },
                    -- win_options = {
                    --     winhighlight = {
                    --         Normal = "Normal",
                    --         FloatBorder = "DiagnosticInfo"
                    --     }
                    -- },
                },
                -- ['cmdline'] = {
                --     backend = 'mini',
                --     relative = 'editor',
                --     align = 'message-left',
                --     timeout = 100,
                --     reverse = true,
                --     text = {
                --         top = " Command ",
                --         top_align = "center", -- "left" | "center" | "right"
                --     },
                --     position = { row = -2, col = 0 },
                --     -- size = 'auto',
                --     size = {
                --         height = 'auto',
                --         width = "100%",
                --     },
                --     max_height = 2,
                --     zindex = 60,

                --     border = {
                --         style = "solid",
                --         -- style = {
                --         --     { '╭', 'NoiceCmdlineBorder' },
                --         --     { '─', 'NoiceCmdlineBorder' },
                --         --     { '╮', 'NoiceCmdlineBorder' },
                --         --     { '╯', 'NoiceCmdlineBorder' },
                --         --     { '─', 'NoiceCmdlineBorder' },
                --         --     { '╰', 'NoiceCmdlineBorder' },
                --         --     { '│', 'NoiceCmdlineBorder' },
                --         -- },
                --         padding = { left = 0, right = 1 },
                --     },

                --     win_options = {
                --         winblend = 6,
                --         winhighlight = {
                --             Normal = "NoiceCmdline", -- sfondo/fg del contenuto
                --             -- FloatBorder = "NoiceCmdlinePopupBorder", -- colore del bordo
                --             IncSearch = '',
                --             Search = ''
                --         },
                --     },
                -- },

                hover = {
                    border = {
                        style = sphynx.config.border_style,
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "NoicePopup",
                            FloatBorder = "NoicePopupBorder",
                        },
                    },
                },

                ["lsp-view"] = {
                    backend = "mini",
                    reverse = true,
                    align = "right",
                    timeout = 2000,
                    position = { row = 1, col = -2 }, -- top-right of window
                    format = { "{message}" },

                    size = {
                        max_height = 5,
                        max_width = math.ceil(0.5 * vim.o.columns),
                        width = "auto",
                        height = "auto",
                    },

                    border = {
                        text = { top = " LSP Progress ", top_align = "right", bottom = "" },
                        style = sphynx.config.border_style,
                        padding = { top = 0, bottom = 0, left = 1, right = 0 },
                    },

                    win_options = { winblend = 6, winhighlight = { Normal = "NoiceLSP" } },
                },
            },

            routes = routes,
        })
    end,
}

return M
