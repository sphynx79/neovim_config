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
 - Indentazione con 7 sfumature di grigio progressivamente più scure (gruppi Rainbow*)
 - Guida di scope sincronizzata con rainbow-delimiters tramite l'hook
   scope_highlight_from_extmark: il colore dello scope segue la parentesi rainbow del livello
 - Configurato per mostrare indentazione di tab con carattere dedicato (→)
 - Supporta linguaggi incorporati (es. JS in HTML) tramite injected_languages
 - Utilizza carattere "▏" per l'indentazione standard e "→" per i tab
 - Scope esteso con nodi treesitter extra per lua, ruby, javascript, typescript e tsx
   (node_type confrontati per uguaglianza esatta: usare i nomi reali dei nodi)
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
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["indent_blankline"] = {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "HiPhish/rainbow-delimiters.nvim" },
        -- after = "nvim-treesitter"
    },
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

        local hooks = require("ibl.hooks")

        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#79839C" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#6B7690" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#606A81" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#555E73" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#4A5264" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#3F4656" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#333946" })
        end)

        -- Gruppi highlight di rainbow-delimiters (stessi nomi/ordine del suo setup):
        -- l'hook scope_highlight_from_extmark legge l'extmark della parentesi rainbow al
        -- confine dello scope e colora la guida di scope con lo stesso colore del livello,
        -- sincronizzando ibl con rainbow-delimiters.
        local rainbow_delimiters_hl = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        }
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

        -- Nodi treesitter usati come "scope" per linguaggio (nomi verificati sui folds.scm
        -- di nvim-treesitter; ibl confronta i node_type con uguaglianza esatta, niente pattern)
        local ruby_scope = {
            "class",
            "module",
            "method",
            "singleton_method",
            "do_block",
            "block",
            "if",
            "case",
            "when",
            "while",
            "for",
            "until",
        }
        local js_scope = {
            "function_declaration",
            "function_expression",
            "arrow_function",
            "method_definition",
            "class_declaration",
            "if_statement",
            "for_statement",
            "for_in_statement",
            "while_statement",
            "switch_statement",
            "try_statement",
            "catch_clause",
        }
        local ts_scope = vim.list_extend(vim.deepcopy(js_scope), {
            "interface_declaration",
            "type_alias_declaration",
            "enum_declaration",
        })
        local tsx_scope = vim.list_extend(vim.deepcopy(ts_scope), {
            "jsx_element",
            "jsx_self_closing_element",
        })

        require("ibl").setup({
            enabled = true,
            debounce = 200, -- Millisecondi di debounce

            viewport_buffer = {
                min = 150, -- Linee extra sopra e sotto la vista corrente
            },

            indent = {
                char = "▏",
                tab_char = "→",
                highlight = highlight,
            },

            whitespace = {
                highlight = { "Whitespace", "NonText" },
                remove_blankline_trail = true,
            },

            scope = {
                enabled = true, -- Attiva la funzionalità scope
                show_start = true, -- Mostra una sottolineatura all'inizio dello scope
                show_end = true, -- Mostra una sottolineatura alla fine dello scope
                injected_languages = true, -- Supporta scope in linguaggi incorporati (es. JS in HTML)
                highlight = rainbow_delimiters_hl, -- colore preso dalla parentesi rainbow al confine (hook scope_highlight_from_extmark)
                priority = 1024, -- Priorità alta per assicurare che sia sempre visibile
                include = {
                    node_type = {
                        lua = { "return_statement", "table_constructor" },
                        ruby = ruby_scope,
                        javascript = js_scope,
                        typescript = ts_scope,
                        tsx = tsx_scope,
                    },
                },
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
        })
    end,
}

return M
