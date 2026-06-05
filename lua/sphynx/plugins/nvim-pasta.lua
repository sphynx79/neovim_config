--[[
===============================================================================================
Plugin: nvim-pasta
===============================================================================================
Description: Potenzia yank/paste: salva la cronologia degli yank e permette di ciclare i
             candidati subito dopo un paste, con fix d'indentazione per i paste line-wise.
Status: Active
Author: hrsh7th
Repository: https://github.com/hrsh7th/nvim-pasta
Notes:
 - Caricamento lazy su VeryLazy.
 - Rimappa p / P in normale e visuale a pasta.mapping; usa i default del plugin senza setup()
   esplicita (next_key = <C-n>, prev_key = <C-p>, indent_key = ",", indent_fix = true).
 - Dopo un paste, <C-n>/<C-p> ciclano i candidati della yank history; indent_fix corregge
   l'indentazione dei paste line-wise.
 - I p / P di nvim-tree sono buffer-local e vincono nel suo buffer (li' p = incolla file,
   P = preview): nessun conflitto con questi bind globali.
 - Convive con neoclip (anch'esso yank history, picker Telescope <leader>ty): UX complementari,
   due ring di yank distinti.
Keymaps:
 - p              → Paste con cronologia (normale/visuale)
 - P              → Paste before con cronologia (normale/visuale)
 - <C-n>/<C-p>    → (subito dopo un paste) candidato successivo/precedente nella yank history
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["nvim-pasta"] = {
        "hrsh7th/nvim-pasta",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["nvim-pasta"] = function()
        vim.keymap.set({ "n", "x" }, "p", require("pasta.mapping").p, { desc = "Paste [nvim-pasta]" })
        vim.keymap.set({ "n", "x" }, "P", require("pasta.mapping").P, { desc = "Paste before [nvim-pasta]" })
    end,
}

return M
