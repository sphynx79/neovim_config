--[[
===============================================================================================
Plugin: vim-mark
===============================================================================================
Description: Evidenzia parole o pattern con colori multipli e persistenti (stile "evidenziatore").
             Porting della configurazione usata in vim (~/vimfiles/vimrc), così da avere
             gli stessi settaggi, colori e keymap tra vim e Neovim.
Status: Active
Author: inkarkat
Repository: https://github.com/inkarkat/vim-mark
Notes:
 - Dipende da inkarkat/vim-ingo-library (dichiarato come dependency).
 - Categorie nominate (DEFAULT/TODO/OK/FIX/PERF/BUG) con colori personalizzati per i gruppi 1-6.
 - L'auto-evidenziazione di TODO:/FIX:/... NON viene fatta qui: la gestisce todo-comments.
 - I colori MarkWord* vengono ridefiniti ad ogni ColorScheme per non perderli al cambio tema.
Keymaps:
 - <leader>bb            → evidenzia la parola sotto il cursore / la selezione (gruppo 1)
 - <leader>bs  (N count) → MarkSet: evidenzia con la categoria N (es. 2<leader>bs = TODO)
 - <leader>bd            → pulisce il mark sotto il cursore
 - <leader>bda           → pulisce tutti i mark
 - <leader>bj / <leader>bk   → mark corrente successivo / precedente
 - <leader>bja / <leader>bka → qualsiasi mark successivo / precedente
 - <leader>bt            → toggle on/off di tutti i mark
 - <leader>bl            → :Marks (lista dei mark attivi)
 - <leader>b1..b9        → cerca avanti nel gruppo N
 - <leader>B1..B9        → cerca indietro nel gruppo N
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["vim-mark"] = {
        "inkarkat/vim-mark",
        dependencies = { "inkarkat/vim-ingo-library" },
        event = "VeryLazy",
    },
}

M.setup = {
    ["vim-mark"] = function()
        -- Variabili da impostare PRIMA del caricamento del plugin
        vim.g.mw_no_mappings = 1                       -- disabilita le mappature di default per ridefinirle
        vim.g.mwAutoLoadMarks = 1                      -- carica automaticamente i mark salvati
        vim.g.mwDefaultHighlightingPalette = "maximum" -- usa la palette piu ampia di colori
        vim.g.mwDefaultHighlightingNum = 9             -- numero di gruppi di evidenziazione

        M.keybindings()
    end,
}

M.configs = {
    ["vim-mark"] = function()
        -- (Ri)definisce nomi categoria e colori dei gruppi
        local function configure_marks()
            vim.cmd([[
                silent! MarkName!
                silent! 1MarkName DEFAULT
                silent! 2MarkName TODO
                silent! 3MarkName OK
                silent! 4MarkName FIX
                silent! 5MarkName PERF
                silent! 6MarkName BUG

                " Colori personalizzati per le categorie (gruppi 1-6)
                highlight MarkWord1 ctermfg=0 ctermbg=11 guifg=Black guibg=#8CCBEA
                highlight MarkWord2 ctermfg=0 ctermbg=14 guifg=Black guibg=#FFDB72
                highlight MarkWord3 ctermfg=0 ctermbg=10 guifg=Black guibg=#A4E57E
                highlight MarkWord4 ctermfg=0 ctermbg=13 guifg=Black guibg=#FFB3FF
                highlight MarkWord5 ctermfg=0 ctermbg=9  guifg=Black guibg=#9999FF
                highlight MarkWord6 ctermfg=0 ctermbg=12 guifg=Black guibg=#FF7272
            ]])
        end

        configure_marks()

        -- Ridefinisce nomi e colori dopo ogni cambio di colorscheme,
        -- altrimenti il tema (nightfox) resetta gli highlight MarkWord*.
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("VimMarkColors", { clear = true }),
            callback = configure_marks,
        })
    end,
}

M.keybindings = function()
    local wk = require("which-key")

    wk.add({
        -- Gruppo puro: cosi which-key mostra i suggerimenti premendo <leader>b
        { "<leader>b", group = "󰸱 Mark" },

        -- MarkSet: con un count assegna la categoria (es. 2<leader>bs = TODO),
        -- senza count usa il prossimo gruppo libero / toggle.
        { "<leader>bs", "<Plug>MarkSet", desc = "mark set (count = gruppo)", mode = { "n", "x" } },

        -- Evidenzia la parola sotto il cursore (gruppo 1)
        {
            "<leader>bb",
            [[<Cmd>execute '1Mark /\V' .. escape(substitute(expand('<cword>'), "'", "''", 'g'), '/\') .. '/'<CR>]],
            desc = "highlight word",
            mode = "n",
        },
        -- Evidenzia la selezione visuale (gruppo 1) — remap necessario per espandere <leader>bs
        { "<leader>bb", [[<Esc>gv1<leader>bs]], desc = "highlight selection", mode = "x", remap = true },

        -- Pulizia
        { "<leader>bd", "<Plug>MarkClear", desc = "clear mark under cursor", mode = "n" },
        { "<leader>bda", "<Plug>MarkAllClear", desc = "clear all marks", mode = "n" },

        -- Navigazione del mark corrente
        { "<leader>bj", "<Plug>MarkSearchCurrentNext", desc = "next current mark", mode = "n" },
        { "<leader>bk", "<Plug>MarkSearchCurrentPrev", desc = "prev current mark", mode = "n" },

        -- Navigazione di qualsiasi mark
        { "<leader>bja", "<Plug>MarkSearchAnyNext", desc = "next any mark", mode = "n" },
        { "<leader>bka", "<Plug>MarkSearchAnyPrev", desc = "prev any mark", mode = "n" },

        -- Toggle e lista
        { "<leader>bt", "<Plug>MarkToggle", desc = "toggle all marks", mode = "n" },
        { "<leader>bl", "<Cmd>Marks<CR>", desc = "list marks", mode = "n" },
    })

    -- Ricerca per gruppo specifico: <leader>b1..b9 (avanti) e <leader>B1..B9 (indietro)
    for i = 1, 9 do
        wk.add({
            { "<leader>b" .. i, "<Plug>MarkSearchGroup" .. i .. "Next", desc = "search group " .. i .. " next", mode = "n" },
            { "<leader>B" .. i, "<Plug>MarkSearchGroup" .. i .. "Prev", desc = "search group " .. i .. " prev", mode = "n" },
        })
    end
end

return M
