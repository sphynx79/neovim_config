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
 - fzf: dichiarata in M.plugins (junegunn/fzf), richiesta per la modalità FZF (tasto 'zf')
 - nvim-treesitter: opzionale, NON dichiarata; se presente migliora il syntax highlighting
   dell'anteprima (delay_syntax)

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
 - Finestra di aiuto flottante ('?') per documentare e mostrare i comandi disponibili

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
 │ ?                   │ Apre/chiude l'aiuto flottante con i tasti reali    │
 └─────────────────────┴────────────────────────────────────────────────────┘

Mouse:
 - <ScrollWheelUp> e <ScrollWheelDown>: Scorre la finestra di anteprima
 - <2-LeftMouse> nella quickfix: Esegue <CR> (apre elemento)
 - <2-LeftMouse> nell'anteprima: Salta alla posizione nel buffer originale

Aiuto (finestra flottante):
 - Dentro la quickfix, '?' apre/chiude una finestra flottante che elenca i TASTI REALI
   utilizzabili (quelli di func_map + <F5>/<F6>), generata dalla tabella `qf_help`
 - La finestra si chiude con q, <Esc> o di nuovo '?'

Note:
 - La funzione drop (tasto 'o') è preferibile perché salta automaticamente
   alla finestra se il file è già aperto, evitando duplicati
 - I file grandi (>100KB) e i buffer fugitive sono esclusi dall'anteprima
   per motivi di performance
 - <F5> e <F6> sono mappati in sphynx.core.5-mapping.lua per toggle e chiusura
   della finestra quickfix globalmente (disponibili in qualsiasi buffer)
 - <Tab> (toggle segno e sposta in giù, stoggledown) NON è impostato in func_map:
   funziona grazie al valore di default di bqf. In func_map sono ridefiniti solo
   stoggleup (<S-Tab>) e stogglevm (<Tab>, modalità visuale)

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
        ft = { "qf" },
        dependencies = {
            "junegunn/fzf",
        },
    },
}

M.configs = {
    ["bqf"] = function()
        require("bqf").setup({
            auto_enable = true,
            auto_resize_height = true, -- highly recommended enable
            preview = {
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                winblend = 5,
                border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
                show_title = false,
                should_preview_cb = function(bufnr, _)
                    local ret = true
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    local fsize = vim.fn.getfsize(bufname)
                    if fsize > 100 * 1024 then
                        -- skip file size greater than 100k
                        ret = false
                    elseif bufname:match("^fugitive://") then
                        -- skip fugitive buffer
                        ret = false
                    end
                    return ret
                end,
            },
            func_map = {
                -- Apertura elementi (navigazione)
                open = "<CR>", -- Apre l'elemento sotto il cursore
                openc = "O", -- Apre l'elemento e chiude la finestra quickfix
                drop = "o", -- Usa 'drop' per aprire l'elemento (salta alla finestra se già aperto) e chiude la quickfix

                -- Gestione tab
                tab = "t", -- Apre l'elemento in una nuova tab
                tabb = "T", -- Apre in nuova tab ma resta nella finestra quickfix
                tabc = "<C-t>", -- Apre in nuova tab e chiude la quickfix

                -- Split
                split = "<C-x>", -- Apre l'elemento in split orizzontale
                vsplit = "<C-v>", -- Apre l'elemento in split verticale

                -- Navigazione tra file nella quickfix
                prevfile = "<C-p>", -- Va al file precedente nella quickfix
                nextfile = "<C-n>", -- Va al file successivo nella quickfix

                -- Navigazione nella storia della quickfix
                prevhist = "<", -- Cicla alla lista quickfix precedente
                nexthist = ">", -- Cicla alla lista quickfix successiva

                -- Gestione segni (filtering con signs)
                stoggleup = "<S-Tab>", -- Attiva/disattiva segno e sposta il cursore in su
                stogglevm = "<Tab>", -- Attiva/disattiva segni multipli in modalità visuale
                sclear = "z<Tab>", -- Cancella i segni nella lista quickfix corrente

                -- Controllo finestra di anteprima
                ptoggleitem = "p", -- Attiva/disattiva anteprima per un elemento
                ptogglemode = "P", -- Alterna la finestra di anteprima tra dimensione normale e massima
                pscrollup = "<PageUp>", -- Scorri in su mezza pagina nella finestra di anteprima
                pscrolldown = "<PageDown>", -- Scorri in giù mezza pagina nella finestra di anteprima
                pscrollorig = "<End>", -- Torna alla posizione originale nella finestra di anteprima

                -- Fzf search & filter
                filter = "zn", -- Crea una nuova lista per gli elementi segnati
                filterr = "zN", -- Crea una nuova lista per gli elementi non segnati
                fzffilter = "zf", -- Entra in modalità fzf
            },
        })

        vim.cmd(([[
            aug Grepper
                au!
                au User Grepper ++nested %s
            aug END
        ]]):format([[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]]))

        -- Elenco dei tasti REALI di bqf (func_map) + tasti globali <F5>/<F6>.
        -- Tenere allineato con func_map sopra: è la sorgente della finestra di aiuto.
        local qf_help = {
            { key = "<CR>", desc = "Apri elemento sotto il cursore" },
            { key = "o", desc = "Apri (drop) e chiudi quickfix" },
            { key = "O", desc = "Apri e chiudi quickfix" },
            { key = "t", desc = "Apri in nuova tab" },
            { key = "T", desc = "Apri in tab (resta in quickfix)" },
            { key = "<C-t>", desc = "Apri in tab e chiudi quickfix" },
            { key = "<C-x>", desc = "Apri in split orizzontale" },
            { key = "<C-v>", desc = "Apri in split verticale" },
            { key = "<C-p>", desc = "File precedente" },
            { key = "<C-n>", desc = "File successivo" },
            { key = "<", desc = "Lista quickfix precedente" },
            { key = ">", desc = "Lista quickfix successiva" },
            { key = "<Tab>", desc = "Toggle segno (giù)" },
            { key = "<S-Tab>", desc = "Toggle segno (su)" },
            { key = "z<Tab>", desc = "Pulisci segni" },
            { key = "p", desc = "Toggle preview elemento" },
            { key = "P", desc = "Toggle preview max size" },
            { key = "<PageUp>", desc = "Scorri preview su" },
            { key = "<PageDown>", desc = "Scorri preview giù" },
            { key = "<End>", desc = "Torna alla posizione originale" },
            { key = "zn", desc = "Filtra elementi segnati" },
            { key = "zN", desc = "Filtra elementi non segnati" },
            { key = "zf", desc = "Modalità FZF" },
            { key = "<F5>", desc = "Toggle quickfix (globale)" },
            { key = "<F6>", desc = "Chiudi quickfix (globale)" },
            { key = "?", desc = "Mostra/nascondi questo aiuto" },
        }

        -- Finestra flottante con i tasti reali utilizzabili nella quickfix (toggle con '?').
        local help_win = nil
        local function show_qf_help()
            -- Se è già aperta, '?' la richiude (toggle)
            if help_win and vim.api.nvim_win_is_valid(help_win) then
                vim.api.nvim_win_close(help_win, true)
                help_win = nil
                return
            end

            -- Larghezza colonna dei tasti = tasto più lungo
            local key_w = 0
            for _, item in ipairs(qf_help) do
                key_w = math.max(key_w, #item.key)
            end

            local lines = {}
            local width = 0
            for _, item in ipairs(qf_help) do
                local line = string.format("  %-" .. key_w .. "s   %s", item.key, item.desc)
                lines[#lines + 1] = line
                width = math.max(width, vim.fn.strdisplaywidth(line))
            end
            width = width + 2

            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].modifiable = false
            vim.bo[buf].bufhidden = "wipe"

            help_win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = #lines,
                row = math.floor((vim.o.lines - #lines) / 2 - 1),
                col = math.floor((vim.o.columns - width) / 2),
                style = "minimal",
                border = sphynx.config.border_style,
                title = " Comandi QuickFix ",
                title_pos = "center",
            })

            -- Chiusura con q / <Esc> / ?
            for _, k in ipairs({ "q", "<Esc>", "?" }) do
                vim.keymap.set("n", k, function()
                    if help_win and vim.api.nvim_win_is_valid(help_win) then
                        vim.api.nvim_win_close(help_win, true)
                        help_win = nil
                    end
                end, { buffer = buf, nowait = true, silent = true })
            end
        end

        -- Nella quickfix '?' apre/chiude l'aiuto con i tasti reali.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "qf",
            callback = function()
                vim.keymap.set("n", "?", show_qf_help, {
                    buffer = 0,
                    nowait = true,
                    silent = true,
                    desc = "Mostra comandi QuickFix",
                })
            end,
        })
    end,
}

return M
