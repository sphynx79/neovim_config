--[[
===============================================================================================
Plugin: pretty-fold.nvim
===============================================================================================
Description: Configura l'aspetto del testo nelle sezioni piegate (fold), mostrando il 
             contenuto a sinistra e il numero di linee piegate a destra con una formattazione
             personalizzata.
Status: Archived (No longer maintained)
Author: anuvyklack
Repository: https://github.com/anuvyklack/pretty-fold.nvim

Notes:
 - Plugin pinnato a versione specifica per stabilità (archived)
 - Caricamento lazy: attivato solo all'apertura del file via on_file_open
 - Ignora i file neorg
 - Configurazione minimalista:
   * A sinistra: contenuto della prima linea
   * A destra: numero di linee piegate e percentuale
   * Separatore: carattere '─'
 - Alternative: 
   * nvim-ufo
   * fold-preview.nvim
   * implementazione custom

Keymaps: (prefix: z "󰊈 Folding")
 Standard Fold:
 - zc/z<Left>   → Chiudi fold corrente
 - zo/z<Right>  → Apri fold corrente
 - za           → Alterna fold
 - zr/z<Down>   → Riduci livello fold di 1
 - zm/z<Up>     → Aumenta livello fold di 1
 - z#           → Imposta livello fold a N

 Custom Actions:
  - zf          → Attiva/disattiva fold automatico al movimento del cursore
                  Quando attivo, le sezioni si chiudono automaticamente
                  quando il cursore si sposta in un'altra parte del file
  - zh          → Folding HTML

 Global Fold: (prefix: zz "+ Fold-Unfold all")
 - zz<Down>/zR  → Apri tutte le fold
 - zz<Up>/zM    → Chiudi tutte le fold

TODO:
 - [ ] Valutare migrazione a nvim-ufo (più mantenuto e moderno)
 - [ ] Considerare implementazione custom per maggiore controllo
 - [ ] Testare alternative per file neorg
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["pretty_fold"] = {
        "anuvyklack/pretty-fold.nvim",
        pin= true,
        lazy = true,
    },
}

M.setup = {
    ["pretty_fold"] = function()
        require("sphynx.utils.lazy_load").on_file_open "pretty-fold.nvim"
    end,
}

M.configs = {
    ["pretty_fold"] = function()
        require('pretty-fold').setup{
            fill_char = '─',
            sections = {
                left = {
                    'content',
                },
                right = {
                    '┼ ', 'number_of_folded_lines', ': ', 'percentage', ' ┤',
                }
            },
            ft_ignore = { 'neorg' },
        }
    end,
}

return M
