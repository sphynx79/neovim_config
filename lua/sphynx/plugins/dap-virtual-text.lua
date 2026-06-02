--[[
===============================================================================================
Plugin: nvim-dap-virtual-text
===============================================================================================
Description: Estensione di nvim-dap che mostra i valori delle variabili come "virtual text"
             inline accanto al codice durante una sessione di debug, usando le informazioni
             di treesitter per individuare le variabili.
Status: Active
Author: theHamsta
Repository: https://github.com/theHamsta/nvim-dap-virtual-text
Dependencies:
 - nvim-dap: e' un'estensione, ha senso solo con una sessione di debug attiva
 - nvim-treesitter: usato per individuare le variabili nel sorgente
Notes:
 - Caricamento lazy.
 - ATTENZIONE: attualmente manca la chiamata require("nvim-dap-virtual-text").setup(),
   quindi l'estensione non viene inizializzata; inoltre, con lazy = true e nessun trigger
   (event/keys) ne' dipendenza da "dap", nulla la carica. Vedi report per il fix.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["dap_virtual_text"] = {
        "theHamsta/nvim-dap-virtual-text",
        name = "dap-virtual-text",
        lazy = true,
    },
}

return M
