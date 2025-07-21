--[[
===============================================================================================
Plugin: nvim-bqf (Better Quickfix)
===============================================================================================
Description: Un plugin per migliorare la finestra quickfix di Neovim, aggiungendo anteprima
             fluttuante, filtri avanzati, integrazione con FZF e navigazione migliorata.
Status: Active
Author: kevinhwang91
Repository: https://github.com/kevinhwang91/nvim-bqf
Dependencies:
 - fzf (opzionale, ma consigliato per modalità filtro)
 - nvim-treesitter (opzionale, ma altamente consigliato per prestazioni migliori)
 - which-key.nvim (per l'integrazione della documentazione scorciatoie)

Funzionalità principali:
 - Anteprima fluttuante per visualizzare i contenuti senza lasciare la quickfix
 - Scorrimento intelligente nella finestra di anteprima
 - "Magic Window" per mantenere l'aspetto della UI confortevole
 - Filtri con segni per creare nuove liste quickfix filtrate
 - Integrazione con FZF per ricerca avanzata all'interno della quickfix
 - Navigazione migliorata tra file, storia quickfix e riferimenti
 - Supporto completo per il mouse nella finestra quickfix e di anteprima

Configurazione:
 - Auto-resize della finestra quickfix abilitato per adattare l'altezza ai contenuti
 - Ottimizzazione per file di grandi dimensioni (skip > 100KB)
 - Bordi personalizzati per la finestra di anteprima
 - Mappatura tastiera personalizzata per scorrevole utilizzo
 - Integrazione with-key per documentare e mostrare i comandi disponibili

Keymaps:
 ┌─────────────────────┬────────────────────────────────────────────────────┐
 │ Apertura elementi   │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ <CR>                │ Apre l'elemento sotto il cursore                   │
 │ o                   │ Apre l'elemento e chiude la quickfix (drop)        │
 │ O                   │ Apre l'elemento e chiude la quickfix (open)        │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Gestione tab        │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ t                   │ Apre in nuova tab                                  │
 │ T                   │ Apre in nuova tab (resta in quickfix)              │
 │ <C-t>               │ Apre in nuova tab e chiude quickfix                │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Split               │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ <C-x>               │ Apre in split orizzontale                          │
 │ <C-v>               │ Apre in split verticale                            │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Navigazione file    │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ <C-p>               │ Va al file precedente nella quickfix               │
 │ <C-n>               │ Va al file successivo nella quickfix               │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Navigazione storia  │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ <                   │ Cicla alla lista quickfix precedente               │
 │ >                   │ Cicla alla lista quickfix successiva               │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Gestione segni      │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ <Tab>               │ Attiva/disattiva segno e sposta in giù             │
 │ <S-Tab>             │ Attiva/disattiva segno e sposta in su              │
 │ <Tab> (visual mode) │ Attiva/disattiva segni su selezione multipla       │
 │ z<Tab>              │ Cancella tutti i segni nella lista corrente        │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Anteprima           │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ p                   │ Attiva/disattiva anteprima per elemento corrente   │
 │ P                   │ Alterna tra dimensione normale e massima anteprima │
 │ <PageUp>            │ Scorri mezza pagina in su nella finestra anteprima │
 │ <PageDown>          │ Scorri mezza pagina in giù nella finestra anteprima│
 │ <End>               │ Torna alla posizione originale nell'anteprima      │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Filtri e FZF        │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ zn                  │ Crea nuova lista con elementi segnati              │
 │ zN                  │ Crea nuova lista con elementi non segnati          │
 │ zf                  │ Entra in modalità FZF per ricerca avanzata         │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Controllo finestra  │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ <F5>                │ Toggle della finestra quickfix (apre/chiude)       │
 │ <F6>                │ Chiude la finestra quickfix                        │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ Aiuto e documentaz. │                                                    │
 ├─────────────────────┼────────────────────────────────────────────────────┤
 │ ?                   │ Mostra finestra whichkey con tutti i comandi       │
 └─────────────────────┴────────────────────────────────────────────────────┘

Mouse:
 - <ScrollWheelUp> e <ScrollWheelDown>: Scorre la finestra di anteprima
 - <2-LeftMouse> nella quickfix: Esegue <CR> (apre elemento)
 - <2-LeftMouse> nell'anteprima: Salta alla posizione nel buffer originale

Integrazione WhichKey:
 - Finestra di help automatica all'apertura della quickfix
 - Modalità hydra attivabile con '?' per mantenere aperta la guida comandi
 - Tasti prefissati con 'q' per visualizzare tutti i comandi disponibili

Note:
 - La funzione drop (tasto 'o') è preferibile perché salta automaticamente
   alla finestra se il file è già aperto, evitando duplicati
 - I file grandi (>100KB) e i buffer fugitive sono esclusi dall'anteprima
   per motivi di performance
 - <F5> e <F6> sono mappati in sphynx.core.5-mapping.lua per toggle e chiusura
   della finestra quickfix globalmente (disponibili in qualsiasi buffer)

TODO:
 - [x] Creare funzione di toggle globale per aprire/chiudere quickfix
 - [ ] Valutare integrazione con altri plugin come Telescope per ricerche avanzate
 - [ ] Considerare aggiunta di syntax highlighting personalizzato per quickfix
============================================================================================
]]


local M = {}

M.plugins = {
    ["bqf"] = {
        "kevinhwang91/nvim-bqf",
        lazy = true,
        name = "bqf",
        ft = {"qf"},
        dependencies = {
            'junegunn/fzf'
        },
    }
}

M.setup = {
    ["bqf"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["bqf"] = function()
        require('bqf').setup({
            auto_enable = true,
            auto_resize_height = true, -- highly recommended enable
            preview = {
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                winblend = 5,
                border = {'┏', '━', '┓', '┃', '┛', '━', '┗', '┃'},
                show_title = false,
                should_preview_cb = function(bufnr, _)
                    local ret = true
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    local fsize = vim.fn.getfsize(bufname)
                    if fsize > 100 * 1024 then
                        -- skip file size greater than 100k
                        ret = false
                    elseif bufname:match('^fugitive://') then
                        -- skip fugitive buffer
                        ret = false
                    end
                    return ret
                end
            },
            func_map = {
                -- Apertura elementi (navigazione)
                open = '<CR>',       -- Apre l'elemento sotto il cursore
                openc = 'O',         -- Apre l'elemento e chiude la finestra quickfix
                drop = 'o',          -- Usa 'drop' per aprire l'elemento (salta alla finestra se già aperto) e chiude la quickfix

                -- Gestione tab
                tab = 't',           -- Apre l'elemento in una nuova tab
                tabb = 'T',          -- Apre in nuova tab ma resta nella finestra quickfix
                tabc = '<C-t>',      -- Apre in nuova tab e chiude la quickfix

                -- Split
                split = '<C-x>',     -- Apre l'elemento in split orizzontale
                vsplit = '<C-v>',    -- Apre l'elemento in split verticale

                -- Navigazione tra file nella quickfix
                prevfile = '<C-p>',  -- Va al file precedente nella quickfix
                nextfile = '<C-n>',  -- Va al file successivo nella quickfix

                -- Navigazione nella storia della quickfix
                prevhist = '<',      -- Cicla alla lista quickfix precedente
                nexthist = '>',      -- Cicla alla lista quickfix successiva

                -- Gestione segni (filtering con signs)
                stoggleup = '<S-Tab>',   -- Attiva/disattiva segno e sposta il cursore in su
                stogglevm = '<Tab>',     -- Attiva/disattiva segni multipli in modalità visuale
                sclear = 'z<Tab>',       -- Cancella i segni nella lista quickfix corrente

                -- Controllo finestra di anteprima
                ptoggleitem = 'p',       -- Attiva/disattiva anteprima per un elemento
                ptogglemode = 'P',       -- Alterna la finestra di anteprima tra dimensione normale e massima
                pscrollup = '<PageUp>',  -- Scorri in su mezza pagina nella finestra di anteprima
                pscrolldown = '<PageDown>',   -- Scorri in giù mezza pagina nella finestra di anteprima
                pscrollorig = '<End>',      -- Torna alla posizione originale nella finestra di anteprima

                -- Fzf search & filter
                filter = 'zn',           -- Crea una nuova lista per gli elementi segnati
                filterr = 'zN',          -- Crea una nuova lista per gli elementi non segnati
                fzffilter = 'zf',        -- Entra in modalità fzf

            },

        })

        vim.cmd(([[
            aug Grepper
                au!
                au User Grepper ++nested %s
            aug END
        ]]):format([[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]]))


        local open_help = function ()
            -- Mostra which-key in modalità hydra per i comandi BQF
            require("which-key").show({
                mode = "n",      -- modalità normale
                keys = "q",
                -- delay = 100,
                auto = true,     -- rilevamento automatico del prefisso (opzionale)
                loop = true,     -- mantiene la finestra aperta fino a Esc
                title = "Comandi QuickFix",
                qf_specific = true, -- flag personalizzato per identificare che è per qf
                sort = { "manual", "local", "order", "group", "alphanum", "mod" },
            })
        end


        -- Crea un autocmd per mostrare la modalità hydra all'apertura della quickfix window
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "qf",
            callback = function()
                -- Piccolo ritardo per assicurarsi che la finestra sia completamente caricata
                vim.defer_fn(function()
                    -- Verifica se siamo ancora nella finestra quickfix (potrebbe essere cambiato)
                    if vim.bo.filetype == "qf" then
                        open_help()
                    end
                end, 150)  -- ritardo di 50ms
            end,
            -- Assicurati che questo autocmd venga eseguito solo una volta per sessione
            once = false,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "qf",
            callback = function()
                -- Usa vim.keymap.set con una funzione anonima locale
                vim.keymap.set('n', '?', function()
                    open_help()
                end, {buffer = 0, desc = "Mostra comandi QuickFix"})
            end
        })

    end
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "q"

    wk.add({
        { prefix, group = " QuickFix", cond = function() return vim.bo.filetype == "qf" end },
        -- Navigazione base
        { prefix .. "?", desc = "Help"  },
        { prefix .. "<CR>", desc = "Apre l'elemento sotto il cursore"  },
        { prefix .. "o", desc = "Apri (drop) e chiudi QF" },
        { prefix .. "O", desc = "Apri e chiudi QF" },
        -- Comandi tab
        { prefix .. "t", desc = "Apri in nuova tab" },
        { prefix .. "T", desc = "Apri in tab (resta in QF)" },
        { prefix .. "<C-t>", desc = "Apri in tab e chiudi QF" },
        -- Split
        { prefix .. "<C-x>", desc = "Apri in split orizzontale" },
        { prefix .. "<C-v>", desc = "Apri in split verticale" },
        -- Navigazione tra file nella quickfix
        { prefix .. "<C-p>", desc = "File precedente" },
        { prefix .. "<C-n>", desc = "File successivo" },
        -- Navigazione nella storia della quickfix
        { prefix .. "<", desc = "Lista QF precedente" },
        { prefix .. ">", desc = "Lista QF successiva" },
        -- Gestione segni (filtering con signs)
        { prefix .."<Tab>", desc = "Toggle segno (giù)" },
        { prefix .. "<S-Tab>", desc = "Toggle segno (su)" },
        { prefix .. "<Tab>", desc = "Toggle segni multipli" },
        { prefix .. "z<Tab>", desc = "Pulisci segni" },
        -- Controllo finestra di anteprima
        { prefix .. "p", desc = "Toggle preview elemento" },
        { prefix .. "P", desc = "Toggle preview max size" },
        { prefix .. "<PageUp>", desc = "Scorri preview su" },
        { prefix .. "<PageDown>", desc = "Scorri preview giù" },
        { prefix .. "<End>", desc = "Torna alla posizione originale" },
        -- Fzf search & filter
        { prefix .. "z", group = "Filter" },
        { prefix .. "zn", desc = "Filtra elementi segnati" },
        { prefix .. "zN", desc = "Filtra elementi non segnati" },
        { prefix .. "zf", desc = "Modalità FZF", icon = { color = "blue", icon = "󰈞" } },
        -- Close & Toggle
        { prefix .. "<F5>", desc = "Toggle quickfix" },
        { prefix .. "<F6>", desc = "Close quickfix" },
    })
end

return M
