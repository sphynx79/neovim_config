--[[
===============================================================================================
Plugin: vim-illuminate
===============================================================================================
Description: Evidenzia automaticamente altre occorrenze della parola sotto il cursore
             utilizzando LSP, Tree-sitter o regex matching.
Status: Active
Author: RRethy
Repository: https://github.com/RRethy/vim-illuminate
Notes:
 - Utilizza tre provider in ordine di priorità: LSP, TreeSitter, Regex
 - Delay impostato a 3000ms per evitare highlighting troppo frequente
 - File considerati "grandi" sopra le 3000 righe
 - Case insensitive per il matching regex
 - Evidenziazione sotto il cursore disabilitata
 - Utilizza la configurazione esterna per i filetypes da escludere
Keymaps:
 - <a-n>                 → Muove al prossimo riferimento
 - <a-p>                 → Muove al riferimento precedente
 - <a-i>                 → Seleziona il riferimento corrente come text object
 - :IlluminatePause     → Mette in pausa il plugin globalmente
 - :IlluminateResume    → Riprende il plugin globalmente
 - :IlluminateToggle    → Attiva/disattiva il plugin globalmente
 - :IlluminatePauseBuf  → Mette in pausa per il buffer corrente
 - :IlluminateResumeBuf → Riprende per il buffer corrente
 - :IlluminateToggleBuf → Attiva/disattiva per il buffer corrente
TODO:
 - [ ] Valutare riduzione del delay a 100-500ms per maggiore reattività
 - [ ] Considerare aumento del large_file_cutoff a 5000-10000 righe
 - [ ] Valutare min_count_to_highlight = 2 per evidenziare solo parole multiple
 - [ ] Verificare performance con i diversi provider
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["illuminate"] = {
        "RRethy/vim-illuminate",
        lazy = true,
    },
}

M.setup = {
    ["illuminate"] = function()
        require("sphynx.utils.lazy_load").on_file_open "vim-illuminate"
    end,
}

M.configs = {
    ["illuminate"] = function()
        require('illuminate').configure({
            providers = {                            -- provider utilizzati per trovare i riferimenti nel buffer, ordinati per priorità
                'lsp',                               -- usa il Language Server Protocol
                'treesitter',                        -- usa TreeSitter per l'analisi sintattica
                'regex',                             -- usa espressioni regolari come fallback
            },
            delay = 3000,                            -- ritardo in millisecondi prima dell'evidenziazione
            filetypes_denylist = sphynx.config.excluded_filetypes,  -- lista di tipi di file da escludere dall'evidenziazione
            filetypes_allowlist = {},                -- lista di tipi di file da includere nell'evidenziazione (vuota = tutti)
            modes_denylist = {},                     -- modalità di Vim da escludere dall'evidenziazione
            modes_allowlist = {},                    -- modalità di Vim da includere nell'evidenziazione (vuota = tutte)
            providers_regex_syntax_denylist = {},    -- sintassi regex da escludere
            providers_regex_syntax_allowlist = {},   -- sintassi regex da includere
            under_cursor = false,                    -- se evidenziare la parola sotto il cursore
            large_file_cutoff = 3000,               -- numero di righe oltre il quale considerare il file come "grande"
            min_count_to_highlight = 1,             -- numero minimo di occorrenze necessarie per l'evidenziazione
            case_insensitive_regex = true,          -- se ignorare maiuscole/minuscole nelle regex
            disable_keymaps = false,                -- se disabilitare le scorciatoie da tastiera predefinite
        })
    end,
}

return M
