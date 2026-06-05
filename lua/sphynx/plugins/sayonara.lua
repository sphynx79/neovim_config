--[[
===============================================================================================
Plugin: vim-sayonara
===============================================================================================
Description: Chiusura intelligente del buffer corrente: il plugin decide da solo tra
             bdelete/close/quit, senza chiudere finestre indesiderate.
Status: Active
Author: mhinz (Marco Hinz)
Repository: https://github.com/mhinz/vim-sayonara
Notes:
 - Caricamento lazy sul comando "Sayonara" (cmd): il plugin si carica al primo uso.
 - :Sayonara  elimina il buffer E chiude la finestra corrente.
 - :Sayonara! elimina il buffer ma PRESERVA la finestra (scratch se era l'ultimo buffer).
 - Non ha mapping di default; i bind globali sono in M.keybindings (which-key li scopre via desc).
 - Bind concorrenti su bc/bC in close-buffers, tabufline e 5-mapping sono commentati: qui vince sayonara.
 - Opzionali g:sayonara_confirm_quit e g:sayonara_filetypes non impostati (non servono qui).
Keymaps:
 - bc   → :Sayonara!   (elimina il buffer, mantiene la finestra)
 - bC   → :Sayonara    (elimina il buffer e chiude la finestra)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["sayonara"] = {
        "mhinz/vim-sayonara",
        lazy = true,
        cmd = "Sayonara",
    },
}

M.setup = {
    ["sayonara"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["sayonara"] = function() end,
}

M.keybindings = function()
    -- nmap bc :Sayonara!<CR>
    vim.keymap.set("n", "bc", "<cmd>Sayonara!<CR>", { silent = true, desc = "Close buffer [Sayonara]" })

    -- nmap bC :Sayonara<CR>
    vim.keymap.set("n", "bC", "<cmd>Sayonara<CR>", { silent = true, desc = "Close buffer and window [Sayonara]" })
end

return M
