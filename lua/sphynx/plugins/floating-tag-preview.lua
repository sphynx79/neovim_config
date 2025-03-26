
--[[
===============================================================================================
Plugin: floating_tag_preview
===============================================================================================
Description: Visualizza i tag in una floating window vicino al cursore, migliorando
             l’esperienza rispetto al preview nativo di Vim/Neovim.
Status: Active
Author: Thore Weilbier
Repository: https://github.com/weilbith/nvim-floating-tag-preview
Notes:
 - Estende i comandi di preview nativi con le versioni `P*` (es. `Ptag`, `Ptjump`, `Psearch`)
 - Apre una floating window prima dell’esecuzione del comando nativo per farla intercettare automaticamente
 - La finestra si chiude al movimento del cursore (configurabile)
 - Supporta highlighting del tag, apertura dei fold, riutilizzo della stessa finestra
 - Comportamento altamente configurabile via variabili globali
 - Compatibile con configurazioni lazy-loading (se ben gestita la fase di bootstrap)
 - Health check disponibile via `:checkhealth floating_tag_preview`
Keymaps:
 - <leader>tp → `:Ptjump <cword>`: Mostra il tag sotto il cursore in una floating window
 - Altri comandi disponibili:
   - :Ptag, :Ptselect, :Ptjump, :Ptnext, :PtNext
   - :Ptprevious, :Ptrewind, :Ptfirst, :Ptlast
   - :Pedit, :Psearch
Variables:
 - `vim.g.floating_tag_preview_height = 40`       → Altezza della finestra
 - `vim.g.floating_tag_preview_width = 130`       → Larghezza della finestra
 - `vim.g.floating_tag_preview_border = "double"` → Bordo "double" (╔═╗)
 - `vim.g.floating_tag_preview_window_options = { number = true }` → Numeri di riga visibili
TODO:
 - [ ] Valutare disattivazione dell’autochiusura in alcuni contesti (es. modalità insert)
 - [ ] Testare configurazioni avanzate di border (es. tabelle unicode personalizzate)
 - [ ] Aggiungere buffer options custom via `g:floating_tag_preview_buffer_options`
 - [ ] Considerare override dei comandi nativi se Neovim lo permetterà in futuro
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["floating_tag_preview"] = {
        "weilbith/nvim-floating-tag-preview",
        lazy = true,
        cmd = {
            "Ptag", "Ptselect", "Ptjump", "Ptnext", "PtNext",
            "Ptprevious", "Ptrewind", "Ptfirst", "Ptlast",
            "Pedit", "Psearch"
        },
    },
}

M.setup = {
    ["floating_tag_preview"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["floating_tag_preview"] = function()
        vim.g.floating_tag_preview_height = 40
        vim.g.floating_tag_preview_width = 130
        vim.g.floating_tag_preview_border = "double"
        vim.g.floating_tag_preview_window_options = {
            number = true     -- mostra i numeri di riga
        }
    end,
}

M.keybindings = function()
    require("which-key").add({
        { "t", group = " Tags" },
        { "tp", [[<Esc>:exe "Ptjump " . expand("<cword>")<CR>]], desc = "Tag Preview [float-tag-preview]" },
    })
end

return M
