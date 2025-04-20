--[[
===============================================================================================
Plugin: indent-blankline.nvim
===============================================================================================
Description: Aggiunge guide di indentazione visive a Neovim utilizzando la funzionalità
             di virtual text, senza usare "conceal". Supporta evidenziazione intelligente
             del contesto semantico (scope) tramite Treesitter.
Status: Active
Author: Lukas Reineke
Repository: https://github.com/lukas-reineke/indent-blankline.nvim
Notes:
 - Utilizza la funzionalità 'virtual text' di Neovim (richiede versione stabile)
 - Supporta scope per evidenziare il contesto semantico corrente (es. funzioni, blocchi)
 - Debounce impostato a 200ms per evitare aggiornamenti troppo frequenti
 - La viewport è configurata per processare 150 linee sopra/sotto la vista corrente
 - Colori "rainbow" con 7 sfumature di grigio progressivamente più scure
 - Configurato per mostrare indentazione di tab con carattere dedicato (→)
 - Supporta linguaggi incorporati (es. JS in HTML) tramite injected_languages
 - Utilizza carattere "│" per l'indentazione standard
 - Configurazione specifica per nodi Lua aggiuntivi (return_statement, table_constructor)
 - Configurazione estesa per nodi Ruby (class, method, if, while, ecc.)
 - Utilizza la configurazione esterna per i filetypes da escludere
 - Priorità elevata (1024) per lo scope per assicurare visibilità
 - Trattamento specifico degli spazi bianchi con highlight dedicato

Keymaps:
 - Nessuna mappatura diretta, ma supporta i seguenti comandi:
 - :IBLEnable         → Attiva il plugin
 - :IBLDisable        → Disattiva il plugin
 - :IBLToggle         → Attiva/disattiva il plugin
 - :IBLEnableScope    → Attiva la funzionalità scope
 - :IBLDisableScope   → Disattiva la funzionalità scope
 - :IBLToggleScope    → Attiva/disattiva la funzionalità scope

TODO:
 - [ ] Valutare l'aggiunta dell'hook scope_highlight_from_extmark per integrazione con plugin rainbow delimiters
 - [ ] Valutare l'abilitazione di repeat_linebreak per la visualizzazione su linee wrappate
 - [ ] Impostare highlight specifico per IblScope invece di usare IndentBlanklineContextChar
 - [ ] Ottimizzare configurazione scope.exclude per linguaggi specifici
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["indent_blankline"] = {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        lazy = true,
        -- event = "BufRead",
        -- after = "nvim-treesitter"
    },
}

M.setup = {
    ["indent_blankline"] = function()
        require("sphynx.utils.lazy_load").on_file_open "indent-blankline.nvim"
    end,
}

M.configs = {
    ["indent_blankline"] = function()

        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local hooks = require "ibl.hooks"

        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#79839C" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#6B7690" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#606A81" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#555E73" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#4A5264" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#3F4656" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#333946" })
            vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#ff8349" })
        end)

        require("ibl").setup {
            enabled = true,
            debounce = 200, -- Millisecondi di debounce

            viewport_buffer = {
                min = 150, -- Linee extra sopra e sotto la vista corrente
            },

            indent = {
                char = "│",
                tab_char = "→",
                highlight = highlight,
            },

            whitespace = {
                highlight = { "Whitespace", "NonText" },
                remove_blankline_trail = true,
            },

            scope = {
                enabled = true,                             -- Attiva la funzionalità scope
                show_start = true,                          -- Mostra una sottolineatura all'inizio dello scope
                show_end = true,                            -- Mostra una sottolineatura alla fine dello scope
                injected_languages = true,                  -- Supporta scope in linguaggi incorporati (es. JS in HTML)
                highlight = "IndentBlanklineContextChar",   -- Gruppo di evidenziazione usato per lo scope
                priority = 1024,                            -- Priorità alta per assicurare che sia sempre visibile
                include = {
                    node_type = {
                        lua = { "return_statement", "table_constructor" },
                        ruby = {
                            'class',
                            'singleton_method',
                            'module',
                            'return',
                            "function",
                            'method',
                            '^if',
                            '^while',
                            'case',
                            'when',
                            'jsx_element',
                            '^for',
                            '^object',
                            "^table",
                            "block",
                            'arguments',
                            'if_statement',
                            'else_clause',
                            'jsx_element',
                            'jsx_self_closing_element',
                            'try_statement',
                            'catch_clause',
                            'import_statement',
                            'operation_type',
                        }
                    }
                }
            },

            exclude = {
                filetypes = sphynx.config.excluded_filetypes,
                buftypes = { "terminal" },
            },

            -- show_first_indent_level = false,
            -- show_trailing_blankline_indent = true,
            -- show_current_context = true,
            -- show_current_context_start = true,
            -- context_highlight_list = {'Warning'},
            -- indentLevel = 6,
            -- show_end_of_line = false,
            -- show_foldtext = false,
        }
    end,
}

return M

