-- NOTE
-- DESCRIZIONE:
--  Nvim-scrollview - Plugin per Neovim che aggiunge barre di scorrimento verticali interattive
--  e trascinabili con il mouse. Fornisce un sistema di "segni" visivi che mostrano la posizione
--  di elementi importanti come errori, risultati di ricerca, conflitti git e sezioni ripiegate
--  del codice. È altamente configurabile e permette di navigare rapidamente tra i vari segni,
--  migliorando l'esperienza di navigazione nel codice.



local M = {}

M.plugins = {
    ["scrollview"] = {
        "dstein64/nvim-scrollview",
        lazy = true,
        -- commit = "14ce355d357c4b10e7dbf4ecc9c6b3533fa69f9f",
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
            signs_on_startup = {                    -- Signs attivi all'avvio
                'diagnostics',                      -- Errori/warning
                'search',                           -- Risultati ricerca
                'marks',                            -- Marks
                'cursor',                           -- Posizione cursore
            },
            diagnostics_error_symbol = "",         -- Simbolo per errori
            diagnostics_warn_symbol  = " ",        -- Simbolo per warning
            diagnostics_info_symbol  = "",         -- Simbolo per info
            diagnostics_hint_symbol  = " ",        -- Simbolo per hint
            search_symbol = '=',                    -- Simbolo per risultati ricerca
            cursor_symbol = '■',                    -- Simbolo per cursore
            diagnostics_severities = {
                vim.diagnostic.severity.ERROR,       -- 1: Mostra errori
                vim.diagnostic.severity.WARN,        -- 2: Mostra warning
                --vim.diagnostic.severity.INFO,      -- 3: Mostra info
                --vim.diagnostic.severity.HINT       -- 4: Mostra suggerimenti
            },

            -- Highlight groups
            highlight_groups = {
                ScrollView = 'Visual',              -- Colore scrollbar
                ScrollViewSearch = 'Search',        -- Colore sign ricerca
                ScrollViewCursor = 'Cursor',        -- Colore sign cursore
                ScrollViewDiagnosticsError = 'DiagnosticError', -- Colore sign errori
                ScrollViewDiagnosticsWarn = 'DiagnosticWarn',   -- Colore sign warning
            }
        }
    end
}

return M

