--[[
===============================================================================================
Plugin: schemastore
===============================================================================================
Description: Catalogo JSON Schema di SchemaStore.org pronto per Neovim: fornisce la mappa
             "nome file -> schema" che jsonls usa per validare e autocompletare i file
             di configurazione noti (package.json, tsconfig.json, ecc.).
Status: Active
Author: b0o
Repository: https://github.com/b0o/SchemaStore.nvim
Notes:
 - Plugin di soli dati: nessun setup(), espone require("schemastore").json.schemas()
 - Caricato da lazy.nvim al primo require (lo usa jsonls in lspconfig.lua)
 - Il contenuto degli schemi viene scaricato dalla rete dal server jsonls alla prima
   apertura del file corrispondente
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["schemastore"] = {
        "b0o/schemastore.nvim",
        lazy = true,
    },
}

return M
