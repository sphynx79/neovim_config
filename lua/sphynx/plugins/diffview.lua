--[[
===============================================================================================
Plugin: diffview.nvim
===============================================================================================
Description: Vista diff git a schermo intero. Permette di esaminare le modifiche del
             working tree, confrontare commit/branch/range e navigare la cronologia
             (file history) di un file o dell'intero repo in una scheda dedicata.
Status: Active
Author: sindrets
Repository: https://github.com/sindrets/diffview.nvim
Notes:
 - Caricamento lazy via "cmd": il plugin si carica solo al primo comando Diffview
 - Dipendenze: plenary.nvim (richiesta) e nvim-web-devicons (icone), gia' presenti in config
 - Configurazione MINIMALE: solo use_icons; tutto il resto ai default del plugin
 - I tasti DENTRO la vista sono i default del plugin (<Tab>/<S-Tab> tra i file,
   - / s stage/unstage, X ripristina, g<C-x> cicla layout, ecc.)
 - Le keymap esterne stanno sotto il prefisso <leader>g (gruppo " Git"), condiviso
   con gitsigns: gitsigns gestisce gli hunk, diffview le viste diff complete
 - Complementare a gitsigns: gitsigns = feedback nel gutter mentre editi;
   diffview = revisione strutturata di commit/branch e cronologia
Keymaps:
 - <leader>gd  → DiffviewOpen          (diff delle modifiche correnti)
 - <leader>gf  → DiffviewFileHistory % (cronologia del file corrente)
 - <leader>gF  → DiffviewFileHistory   (cronologia dell'intero repo)
 - <leader>gc  → DiffviewClose         (chiude la vista)
TODO:
 - [ ] Valutare keymap per DiffviewToggleFiles / DiffviewFocusFiles
 - [ ] Valutare layout verticale (diff2_vertical) o vista a 3 vie per i merge
 - [ ] Valutare confronto rapido contro un branch (es. DiffviewOpen main..HEAD)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["diffview"] = {
        "sindrets/diffview.nvim",
        lazy = true,
        cmd = {                                  -- comandi che attivano il caricamento lazy
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewFileHistory",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
        },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}

M.setup = {
    ["diffview"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["diffview"] = function()
        require("diffview").setup({
            use_icons = true,                    -- usa nvim-web-devicons nel pannello file
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>g"

    wk.add({
        -- Gruppo Git condiviso con gitsigns
        { prefix, group = " Git" },
        { prefix .. "d", [[<Cmd>DiffviewOpen<CR>]], desc = "diffview: modifiche correnti" },
        { prefix .. "f", [[<Cmd>DiffviewFileHistory %<CR>]], desc = "diffview: storia file" },
        { prefix .. "F", [[<Cmd>DiffviewFileHistory<CR>]], desc = "diffview: storia repo" },
        { prefix .. "c", [[<Cmd>DiffviewClose<CR>]], desc = "diffview: chiudi" },
    }, mapping.opt_mappping)
end


return M
