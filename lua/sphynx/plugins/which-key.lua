--[[
===============================================================================================
Plugin: which-key.nvim
===============================================================================================
Description: Visualizza una finestra popup con i possibili tasti e combinazioni disponibili
             mentre digiti, aiutandoti a ricordare le tue mappature dei tasti in Neovim.
Status: Active
Author: folke
Repository: https://github.com/folke/which-key.nvim
Notes:
 - Impostato con layout "helix" per un'interfaccia moderna
 - Ritardo impostato a 500ms per evitare popup indesiderati durante la digitazione veloce
 - Filtro per escludere mappature senza descrizione
 - Trigger automatici in modalità normale, visual, operatore, selezione e terminale
 - Trigger aggiuntivi per tasti singoli: w, b, t, e, m, q in modalità normale
 - Plugin integrati disabilitati (marks, registers, spelling, presets)
 - Finestra popup configurata con bordo "single" e non si sovrappone al cursore
 - Layout centrato con spaziatura di 4 e larghezza minima di 20 caratteri
 - Icone personalizzate per tasti speciali come Space → "SPC", Tab → "TAB"
 - Icone per mappature disabilitate (mappings = false)

Caratteristiche abilitate:
 - Notifiche per problemi nelle mappature (notify = true)
 - Finestra senza sovrapposizione al cursore (no_overlap = true)
 - Visualizzazione centrata (align = "center")
 - Tasti speciali con icone personalizzate (Space = "SPC", Tab = "TAB", ecc.)

Caratteristiche disabilitate:
 - Debug (debug = false)
 - Plugin marks e registers
 - Suggerimenti per spelling
 - Preset per operators, motions, text_objects, windows, nav, z, g

Da sapere:
 - Viene caricato in lazy-loading con evento "VeryLazy"
 - Viene nascosto nei tipi di file specificati in sphynx.config.excluded_filetypes

Keymaps disponibili durante popup:
 - <esc>   → Chiude il popup
 - <bs>    → Torna al livello precedente
 - <c-d>   → Scorre verso il basso
 - <c-u>   → Scorre verso l'alto

TODO:
 - [ ] Valutare se attivare plugin integrati come marks o registers
 - [ ] Considerare l'aggiunta del tasto leader come trigger (<leader>, mode = "nxsotv")
 - [ ] Aggiungere opzioni di ordinamento (sort) e espansione (expand)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["which_key"] = {
        "folke/which-key.nvim",
        lazy = true,
        event = "VeryLazy"
    },
}

M.configs = {
    ["which_key"] = function()
        require('which-key').setup {
            preset = "helix",
            debug = false,
            -- show a warning when issues were detected with your mappings
            notify = true,
            delay = function(ctx)
                return ctx.plugin and 0 or 500
            end,
            filter = function(mapping)
                -- example to exclude mappings without a description
                -- -- return mapping.desc and mapping.desc ~= ""
                return mapping.desc and mapping.desc ~= ""
            end,
            triggers = {
                { "<auto>", mode = "nxsot" },
                --{ "<leader>", mode = "nxsotv" },
                { "w", mode = "n" },
                { "b", mode = "n" },
                { "t", mode = "n" },
                { "e", mode = "n" },
                { "m", mode = "n" },
                { "q", mode = "n" },
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
                no_overlap = true,
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
                separator = "",   -- symbol used between a key and it's label
                group = "+",      -- symbol prepended to a group
                ellipsis = "…",
                mappings = false,
            },
            disable = {
                bt = {},
                ft = sphynx.config.excluded_filetypes,
            },
            keys = {
                Up = " ",
                Down = " ",
                Left = " ",
                Right = " ",
                C = "󰘴 ",
                M = "󰘵 ",
                D = "󰘳 ",
                S = "󰘶 ",
                CR = "󰌑 ",
                Esc = "󱊷 ",
                ScrollWheelDown = "󱕐 ",
                ScrollWheelUp = "󱕑 ",
                NL = "󰌑 ",
                BS = "󰁮",
                Space = "SPC",
                Tab = "TAB",
                F1 = "󱊫",
                F2 = "󱊬",
                F3 = "󱊭",
                F4 = "󱊮",
                F5 = "󱊯",
                F6 = "󱊰",
                F7 = "󱊱",
                F8 = "󱊲",
                F9 = "󱊳",
                F10 = "󱊴",
                F11 = "󱊵",
                F12 = "󱊶",
            },

        }
    end,
}

return M

