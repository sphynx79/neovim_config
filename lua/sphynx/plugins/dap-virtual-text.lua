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
 - Caricamento lazy: dichiarato come dependency di nvim-dap in dap.lua, quindi viene
   caricato insieme al debugger (di cui e' un'estensione).
 - Inizializzazione in M.configs con require("nvim-dap-virtual-text").setup({}).
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

M.configs = {
    ["dap_virtual_text"] = function()
        require("nvim-dap-virtual-text").setup({
             show_stop_reason = false,
             virt_text_win_col = 80,
             highlight_changed_variables = true
        })
    end,
}

return M
