--[[
===============================================================================================
Plugin: foldsigns.nvim
===============================================================================================
Description: Gestisce la visualizzazione dei segni (signs) nelle sezioni di codice piegate,
             evitando che si sovrappongano o creino disordine visivo.

Status: Active
Author: lewis6991
Repository: https://github.com/lewis6991/foldsigns.nvim

Notes:
 - Caricamento lazy tramite evento "file open"
 - Integrazione automatica con il sistema di folding di Neovim
 - Utile per mantenere pulita l'interfaccia quando si usano molti segni

Keymaps:
 - Nessuna mappatura specifica, funziona automaticamente

TODO:
    - Nessuna todo specifica, funziona automaticamente gia bene
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["foldsigns"] = {
        "lewis6991/foldsigns.nvim",
        lazy = true,
        name = "foldsigns",
    },
}

M.setup = {
    ["foldsigns"] = function()
        require("sphynx.utils.lazy_load").on_file_open "foldsigns"
    end,
}

M.configs = {
    ["foldsigns"] = function()
        require('foldsigns').setup()
    end,
}

return M

