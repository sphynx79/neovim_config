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
 - USATO SOLO per il fix d'indentazione: l'accumulo della yank history e' disabilitato via
   monkey-patch in M.configs (add_entry tiene solo l'ultimo registro). Quindi <C-n>/<C-p>
   non hanno nulla da ciclare; il toggle indent con "," resta attivo. indent_fix corregge
   l'indentazione dei paste line-wise.
 - I p / P di nvim-tree sono buffer-local e vincono nel suo buffer (li' p = incolla file,
   P = preview): nessun conflitto con questi bind globali.
 - La yank history vera e propria resta a neoclip (picker Telescope <leader>ty); nvim-pasta
   non tiene piu' un ring proprio.
Keymaps:
 - p              → Paste con indent-fix (normale/visuale)
 - P              → Paste before con indent-fix (normale/visuale)
 - ","            → (durante il paste) attiva/disattiva al volo il fix d'indentazione
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
        local pasta = require("pasta")

        -- Disabilita l'accumulo della yank history: tiene solo l'ultimo registro.
        -- p/P fanno solo il paste con indent-fix; <C-n>/<C-p> non hanno nulla da ciclare.
        -- Monkey-patch: nessuna opzione nativa esiste (fragile, va rivisto se si aggiorna il plugin).
        pasta.add_entry = function(e)
            if pasta.running then
                return
            end
            pasta.history = { { regtype = e.regtype, regcontents = e.regcontents } }
        end

        vim.keymap.set({ "n", "x" }, "p", require("pasta.mapping").p, { desc = "Paste [nvim-pasta]" })
        vim.keymap.set({ "n", "x" }, "P", require("pasta.mapping").P, { desc = "Paste before [nvim-pasta]" })
    end,
}

return M
