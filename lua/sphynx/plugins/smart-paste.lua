--[[
===============================================================================================
Plugin: smart-paste.nvim
===============================================================================================
Description: Paste intelligente: reindenta automaticamente il contenuto incollato in base al
             contesto (p/P/gp/gP e ]p/[p), rispettando l'indentazione del punto di inserimento.
Status: Active
Author: nemanjamalesija
Repository: https://github.com/nemanjamalesija/smart-paste.nvim
Notes:
 - Caricamento lazy su evento VeryLazy: il plugin e' un miglioramento passivo dei tasti paste.
 - Il modulo Lua e' "smart-paste" (trattino), come il repo.
 - ATTENZIONE: rimappa p/P/gp/gP proprio come nvim-pasta. Se entrambi sono attivi vince
   l'ultimo caricato: tenere attivo un solo plugin di paste per evitare conflitti.
 - exclude_filetypes vuoto: nessun filetype escluso dallo smart indent.
Keymaps:
 - p / P / gp / gP   → paste con reindentazione automatica
 - ]p / [p           → paste charwise come nuova riga indentata
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["smart-paste"] = {
        "nemanjamalesija/smart-paste.nvim",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["smart-paste"] = function()
        require("smart-paste").setup({
            exclude_filetypes = {}, -- filetype che saltano lo smart indent
        })
    end,
}

return M
