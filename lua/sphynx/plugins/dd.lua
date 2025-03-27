--[[
Plugin: nvim-dd
Description: Un plugin per NeoVim che si occupa di rimandare (defer) tutti i diagnostici,
migliorando le performance e l'esperienza utente.
Status: Inactive
Author: Yorick Peterse
Repository: https://github.com/yorickpeterse/nvim-dd
Notes:
 - Rimanda l'esecuzione dei diagnostici per migliorare le performance
 - Riduce il consumo di CPU durante la digitazione
 - Previene continue interruzioni mentre si scrive codice
 - Mostra i diagnostici solo quando si è in idle, non durante la digitazione attiva
 - Leggero con impatto minimo sulle risorse del sistema
 - Non richiede configurazioni particolari per la maggior parte degli use case
 - Si integra perfettamente con il sistema di diagnostici nativo di NeoVim
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["dd"] = {
        "https://gitlab.com/yorickpeterse/nvim-dd",
        lazy = true,
        name = "dd",
        event = "LspAttach",
    },
}

M.configs = {
    ["dd"] = function()
        require('dd').setup({
            timeout = 4000
        })
    end,
}

return M
