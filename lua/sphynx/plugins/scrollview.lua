--[[
===============================================================================================
Plugin: nvim-scrollview
===============================================================================================
Description: Aggiunge barre di scorrimento verticali interattive e un sistema di segni visivi 
             per diagnostica, ricerca, marcatori e posizione del cursore.
Status: Active
Author: dstein64
Repository: https://github.com/dstein64/nvim-scrollview

Notes:
 - Mostra solo nella finestra corrente (current_only = true)
 - Nasconde i segni quando intersecano il cursore
 - Disabilitate le info e i suggerimenti della diagnostica
 - Trasparenza impostata al 20%
 - I segni non vengono mostrati nelle sezioni piegate del codice
 - Alternativa: usare solo signcolumn con trouble.nvim per la diagnostica

Keymaps:
 - :ScrollViewDisable     → Disabilita plugin
 - :ScrollViewEnable      → Abilita plugin 
 - :ScrollViewToggle      → Attiva/disattiva plugin
 - :ScrollViewRefresh     → Aggiorna scrollbars e segni
 - :ScrollViewLegend      → Mostra legenda dei segni

TODO:
 - [ ] Valutare se spostare la diagnostica su trouble.nvim
 - [ ] Testare performance con file grandi
 - [ ] Verificare compatibilità con altri plugin che usano la signcolumn

===============================================================================================
--]]

local M = {}

M.plugins = {
    ["scrollview"] = {
        "dstein64/nvim-scrollview",
        lazy = true,
    },
}

M.setup = {
    ["scrollview"] = function()
        require("sphynx.utils.lazy_load").on_file_open "nvim-scrollview"
    end,
}

M.configs = {
    ["scrollview"] = function()
        -- vim.api.nvim_command([[au InsertEnter * ScrollViewDisable]])
        -- vim.api.nvim_command([[au InsertLeave * ScrollViewEnable]])

        require('scrollview').setup{
            -- Configurazione base
            always_show = false,                                        -- Mostra le scrollbars anche quando tutte le linee sono visibili
            excluded_filetypes = sphynx.config.excluded_filetypes,      -- Lista di filetype da escludere
            current_only = true,                                        -- Mostra solo nella finestra corrente
            hide_on_intersect = true,                                   -- Nascondi quando interseca il cursore
            hover = false,                                              -- Evidenzia al passaggio del mouse
            mode = 'proper',                                            -- Modalità completa ('simple', 'virtual', 'proper', 'auto')
            winblend = 20,                                              -- Livello di trasparenza (0-100)
            column = 1,
            zindex = 1000,                                              -- Z-index delle finestre scrollview
            signs_show_in_folds = false,                                -- Mostra segni nelle linee piegate

            -- Signs configuration
            signs_on_startup = {                                        -- Signs attivi all'avvio
                'diagnostics',                                          -- Errori/warning
                'search',                                               -- Risultati ricerca
                'marks',                                                -- Marks
                'cursor',                                               -- Posizione cursore
            },
            diagnostics_error_symbol = "",                             -- Simbolo per errori
            diagnostics_warn_symbol  = " ",                            -- Simbolo per warning
            diagnostics_info_symbol  = "",                             -- Simbolo per info
            diagnostics_hint_symbol  = " ",                            -- Simbolo per hint
            search_symbol = '=',                                        -- Simbolo per risultati ricerca
            cursor_symbol = '■',                                        -- Simbolo per cursore
            diagnostics_severities = {
                vim.diagnostic.severity.ERROR,                           -- 1: Mostra errori
                vim.diagnostic.severity.WARN,                            -- 2: Mostra warning
                --vim.diagnostic.severity.INFO,                          -- 3: Mostra info
                --vim.diagnostic.severity.HINT                           -- 4: Mostra suggerimenti
            },

            -- Highlight groups
            highlight_groups = {
                ScrollView = 'Visual',                                  -- Colore scrollbar
                ScrollViewSearch = 'Search',                            -- Colore sign ricerca
                ScrollViewCursor = 'Cursor',                            -- Colore sign cursore
                ScrollViewDiagnosticsError = 'DiagnosticError',         -- Colore sign errori
                ScrollViewDiagnosticsWarn = 'DiagnosticWarn',           -- Colore sign warning
            }
        }
    end
}

return M

