--[[
===============================================================================================
Plugin: spaceless.nvim
===============================================================================================
Description: Rimuove automaticamente gli spazi finali (trailing whitespace) dalle righe che
             modifichi in insert mode, senza toccare il resto del file (niente diff rumorosi).
Status: Active
Author: lewis6991
Repository: https://github.com/lewis6991/spaceless.nvim
Notes:
 - Caricamento lazy all'apertura di un file (on_file_open) tramite sphynx.utils.lazy_load.
 - Nessuna setup() richiesta: l'inizializzazione (augroup + autocmd InsertEnter/Leave,
   BufEnter/Leave) avviene automaticamente in plugin/spaceless.lua al caricamento.
 - La vecchia require("spaceless").setup() e' un no-op marcato @deprecated (emette vim.deprecate):
   rimossa di proposito, non va piu' chiamata.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["spaceless"] = {
        "lewis6991/spaceless.nvim",
        lazy = true,
        name = "spaceless",
    },
}

M.setup = {
    ["spaceless"] = function()
        require("sphynx.utils.lazy_load").on_file_open("spaceless")
    end,
}

return M
