--[[
===============================================================================================
Plugin: gitsigns.nvim
===============================================================================================
Description: Mostra nel gutter (signcolumn) i segni delle modifiche git riga per riga
             rispetto all'index e permette di navigare, visualizzare in anteprima e
             ispezionare (blame) gli hunk direttamente da Neovim.
Status: Active
Author: lewis6991
Repository: https://github.com/lewis6991/gitsigns.nvim
Notes:
 - Caricamento lazy tramite eventi nativi lazy.nvim all'apertura di un file
 - Configurazione MINIMALE: solo signs nel gutter + navigazione/preview/blame
 - Un "hunk" e' un blocco contiguo di righe modificate rispetto all'ultimo commit
 - add e change sono distinti sia dal glifo che dal colore (verde / giallo); delete in rosso
 - Le keymap usano il prefisso <leader>g (g = git); navigazione con le frecce su/giu
 - Funzioni disponibili ma NON abilitate qui: stage/reset hunk e buffer, toggle blame
   inline (current_line_blame), word_diff, numhl/linehl, diffthis, quickfix, text-object
Keymaps:
 - <leader>g<Down>  → Vai all'hunk successivo
 - <leader>g<Up>    → Vai all'hunk precedente
 - <leader>gp       → Anteprima dell'hunk sotto il cursore (popup flottante)
 - <leader>gb       → Blame della riga corrente (popup)
TODO:
 - [ ] Valutare current_line_blame attivo all'avvio invece che solo via toggle
 - [ ] Valutare keymap di stage/reset hunk (<leader>gs / <leader>gr) se servono
 - [ ] Valutare text-object "ih" per selezionare l'hunk in visual/operator-pending
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["gitsigns"] = {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Gitsigns",
    },
}

M.setup = {
    ["gitsigns"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["gitsigns"] = function()
        require("gitsigns").setup({
            signs = { -- segni mostrati nel gutter per le righe non staged
                add = { text = "┃" }, -- riga aggiunta      (verde)
                change = { text = "┃" }, -- riga modificata    (giallo)
                delete = { text = "✗" }, -- riga eliminata     (rosso)
                topdelete = { text = "✗" }, -- eliminazione in cima al file
                changedelete = { text = "~" }, -- riga modificata e in parte eliminata
                untracked = { text = "┆" }, -- file non tracciato
            },
            signcolumn = true, -- mostra i segni nella signcolumn
            numhl = false, -- non evidenziare il numero di riga
            linehl = false, -- non evidenziare l'intera riga
            word_diff = false, -- niente diff intra-riga (parola per parola)
            current_line_blame = false, -- blame inline spento all'avvio (resta come funzione, qui senza toggle)
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>g"

    wk.add({
        -- Gruppo Git condiviso con diffview
        { prefix, group = " Git" },
        { prefix .. "<Down>", [[<Cmd>Gitsigns next_hunk<CR>]], desc = "hunk successivo" },
        { prefix .. "<Up>", [[<Cmd>Gitsigns prev_hunk<CR>]], desc = "hunk precedente" },
        { prefix .. "p", [[<Cmd>Gitsigns preview_hunk<CR>]], desc = "preview hunk" },
        { prefix .. "b", [[<Cmd>Gitsigns blame_line<CR>]], desc = "blame riga" },
    }, mapping.opt_mappping)
end

return M
