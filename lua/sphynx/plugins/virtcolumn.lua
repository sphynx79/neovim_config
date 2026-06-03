--[[
===============================================================================================
Plugin: virt-column.nvim
===============================================================================================
Description: Disegna una colonna verticale "virtuale" (come colorcolumn) usando virtual text,
             senza colorare la cella di sfondo: un sottile separatore alla colonna indicata.
Status: Active
Author: lukas-reineke (qui fork sphynx79)
Repository: https://github.com/sphynx79/virt-column.nvim
Notes:
 - Fork personale pinnato (pin = true) al commit 7c12ad4 "Fix Neovim 0.12 vim.validate
   deprecations": l'upstream usa la vecchia firma di vim.validate, deprecata in Neovim 0.12.
 - Caricamento lazy su evento BufReadPost: la colonna compare all'apertura di un file.
 - char = "▕" (U+2595): separatore sottile (display width 1, richiesto dal plugin).
 - virtcolumn = "100": colonna assoluta a 100 caratteri (stringa; supporta anche liste tipo
   "80,100" o valori relativi a textwidth come "+1").
 - highlight = "VirtColumn": gruppo auto-definito dal plugin (link a Whitespace, default = true),
   quindi un eventuale colorscheme puo' ridefinirlo.
 - exclude non impostato: usa la lista di filetypes/buftypes esclusi di default dal plugin.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["virtcolumn"] = {
        "sphynx79/virt-column.nvim",
        lazy = true,
        event = "BufReadPost",
        pin = true,
        commit = "7c12ad40adbb7ebcecbe72942c42837b66fe5985",
    },
}

M.configs = {
    ["virtcolumn"] = function()
        require("virt-column").setup({
            char = "▕",
            virtcolumn = "100",
            highlight = "VirtColumn",
        })
    end,
}

return M
