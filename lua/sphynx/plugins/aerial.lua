--[[
===============================================================================================
Plugin: aerial.nvim
===============================================================================================
Description: Mostra una finestra con la struttura (outline) del codice — funzioni, classi,
             metodi e simboli del buffer corrente — sfruttando LSP/Treesitter. Sostituisce
             plugin tipo vista/symbols-outline per navigare rapidamente tra i tag.
Status: Active
Author: stevearc
Repository: https://github.com/stevearc/aerial.nvim
Notes:
 - Caricamento lazy: si attiva solo con i comandi AerialToggle / AerialNavToggle / AerialOpen.
 - La sorgente dei simboli è gestita automaticamente da aerial (LSP quando disponibile,
   altrimenti Treesitter).
Keymaps:
 - <F7> → AerialToggle: apre/chiude la lista dei tag (Tag-LSP) del buffer corrente
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["aerial"] = {
        "stevearc/aerial.nvim",
        lazy = true,
        cmd = { "AerialToggle", "AerialNavToggle", "AerialOpen" },
    },
}

M.setup = {
    ["aerial"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["aerial"] = function()
        require("aerial").setup({})
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n" },
            lhs = "<F7>",
            rhs = [[<Cmd>AerialToggle<CR>]],
            options = { silent = true },
            description = "Open vista Tag-LSP list",
        },
    })
end

return M
