--[[
===============================================================================================
Plugin: lazydev.nvim
===============================================================================================
Description: Abilita una migliore esperienza di sviluppo Lua in Neovim con completamento,
             tipi e documentazione migliorata per plugin come lazy.nvim e luv.
Status: Active
Author: folke
Repository: https://github.com/folke/lazydev.nvim
Notes:
 - Funziona solo in file Lua (`ft = "lua"`)
 - Caricamento lazy per migliorare performance
 - Aggiunge annotazioni di tipo per plugin Lua tramite metadati LSP
 - Usa `luvit-meta` come dipendenza per i tipi luv (Bilal2453/luvit-meta)
 - Si integra perfettamente con il setup di `lazy.nvim` e `nvim-lspconfig`
 - Richiede configurazione per includere percorsi della libreria e pattern per parole chiave
 - `"vim%.uv"` è un pattern regex che migliora il riconoscimento dei tipi per `vim.uv`
Keymaps:
 - Nessuna mappatura di default: il plugin agisce "dietro le quinte"
 - Si consiglia integrazione con `lua_ls` o altri LSP compatibili con Lua
 - Personalizzazione e introspezione tramite `:lua =require("lazydev")`
TODO:
 - [ ] Aggiungere supporto nativo per altri plugin Lua diffusi
 - [ ] Esplorare compatibilità con setup Neovim embedded (es. nvim as library)
 - [ ] Automatizzare rilevamento librerie Lua personalizzate
 - [ ] Fornire template di configurazione per altri plugin manager oltre Lazy
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["lazydev"] = {
        "folke/lazydev.nvim",
        ft = "lua",
        lazy = true,
        dependencies = { "Bilal2453/luvit-meta", lazy = true }
    },
}

M.configs = {
    ["lazydev"] = function()
        require('lazydev').setup({
            library = {
                -- Usa la sintassi raccomandata per i tipi luv
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                -- Includi lazy.nvim
                "lazy.nvim",
            },
        })
    end,
}

return M
