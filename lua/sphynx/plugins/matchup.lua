--[[
===============================================================================================
Plugin: vim-matchup
===============================================================================================
Description: Estende il % di Vim a parole specifiche del linguaggio (if/endif, do/end, tag HTML,
             ecc.), evidenzia la coppia sotto il cursore e aggiunge motion g%/[%/]%/z% e i
             text-object i%/a%. Rimpiazza matchit e matchparen.
Status: Active
Author: andymass (Andy Massimino)
Repository: https://github.com/andymass/vim-matchup
Notes:
 - Caricamento lazy su evento CursorMoved: matchup si attiva al primo movimento del cursore.
 - Su Neovim usa di default il motore treesitter per calcolare i match (nessun setup richiesto).
 - matchparen_deferred = 1 + deferred_show_delay = 450: evidenziazione differita di 450 ms per
   non rallentare lo scorrimento con hjkl (la coppia si illumina quando il cursore si ferma).
 - delim_noskips = 2: nessun match dentro stringhe e commenti.
 - matchparen_nomode = "i": evidenziazione disattivata in insert mode.
 - matchparen_timeout = 250 / insert_timeout = 40: tetti di tempo (ms) per l'evidenziazione.
 - motion_cursor_end = 0: con %/]% il cursore resta a inizio parola (non salta alla fine).
 - offscreen = {}: disabilitata la preview del match fuori schermo (solo visualizzazione;
   motion e selezioni i%/a% verso un gemello fuori schermo continuano a funzionare).
 - MatchParen ridefinito (sfondo grigio #5c6370, corsivo) al caricamento del plugin.
Keymaps (default del plugin, nessuna rimappatura custom):
 - %        → vai alla parola corrispondente      - g% → alla precedente corrispondente
 - [% / ]%  → apertura/chiusura del blocco esterno - z%  → dentro il blocco piu' vicino
 - i% / a%  → text-object interno / blocco intero (visual e operator-pending)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["matchup"] = {
        "andymass/vim-matchup",
        lazy = true,
        event = "CursorMoved",
    },
}

M.configs = {
    ["matchup"] = function()
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_deferred_show_delay = 450
        vim.g.matchup_delim_noskips = 2
        vim.g.matchup_matchparen_pumvisible = 1
        vim.g.matchup_motion_cursor_end = 0
        vim.g.matchup_matchparen_nomode = "i"
        vim.g.matchup_matchparen_timeout = 250
        vim.g.matchup_matchparen_insert_timeout = 40
        vim.g.matchup_matchparen_offscreen = {}
        vim.cmd([[hi MatchParen ctermbg=blue guibg=#5c6370 cterm=italic gui=italic]])
    end,
}

return M
