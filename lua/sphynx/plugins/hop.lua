--[[
===============================================================================================
Plugin: hop.nvim
===============================================================================================
Description: Motion plugin in stile EasyMotion: evidenzia le destinazioni (parole, pattern,
             posizioni) con etichette di 1-2 lettere e ci salta digitando l'etichetta.
Status: Active
Author: smoka7 (fork mantenuto di phaazon/hop.nvim)
Repository: https://github.com/smoka7/hop.nvim
Notes:
 - Caricamento lazy: il plugin si carica al primo require('hop') da una keymap.
 - Etichette generate dai tasti "qwertyuiopasdfghjklzxcvbnm" (vedi setup).
 - I salti sono mappati sul prefisso "h" (NON <leader>h): "h" come movimento a sinistra e'
   sacrificato di proposito, perche' ci si muove con hop. Per far comparire il popup di
   which-key su "h" serve la voce { "h", mode = "n" } nei triggers di which-key.lua
   (<auto> non triggera i movimenti nativi).
 - Anche "f" e "F" sono rimappati su hop sulla linea corrente (inizio/fine parola),
   sacrificando il find-char nativo.
Keymaps:
 - hh      → Hop omnidirezionale (tutto il buffer)
 - hl      → Hop sulla linea corrente
 - h<Up>   → Hop solo verso l'alto       - h<Down> → Hop solo verso il basso
 - hH      → Hop tra finestre            - hs      → Hop ricerca pattern
 - f       → Hop inizio parola (linea)   - F       → Hop fine parola (linea)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["hop"] = {
        "smoka7/hop.nvim",
        lazy = true,
        name = "hop",
        -- keys = {"è","ò","à","f"},
    },
}

M.setup = {
    ["hop"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["hop"] = function()
        require("hop").setup({ keys = "qwertyuiopasdfghjklzxcvbnm" })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    wk.add({
        { "h", group = "󰋟 Hop" },
    })
    mapping.register({
        {
            mode = { "n" },
            lhs = "hh",
            rhs = [[<Cmd>lua require'hop'.hint_words()<CR>]],
            options = { silent = true },
            description = "Hop omnidirezionale (tutto il buffer)",
        },
        {
            mode = { "n" },
            lhs = "hl",
            rhs = [[<Cmd>lua require'hop'.hint_words({ current_line_only = true })<CR>]],
            options = { silent = true },
            description = "Hop sulla linea corrente",
        },
        {
            mode = { "n" },
            lhs = "h<Up>",
            rhs = [[<Cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<CR>]],
            options = { silent = true },
            description = "Hop solo verso l'alto",
        },
        {
            mode = { "n" },
            lhs = "h<Down>",
            rhs = [[<Cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<CR>]],
            options = { silent = true },
            description = "Hop solo verso il basso",
        },
        {
            mode = { "n" },
            lhs = "hH",
            rhs = [[<Cmd>lua require'hop'.hint_words({ multi_windows = true })<CR>]],
            options = { silent = true },
            description = "Hop tra finestre",
        },
        {
            mode = { "n" },
            lhs = "hs",
            rhs = [[<Cmd>lua require'hop'.hint_patterns()<CR>]],
            options = { silent = true },
            description = "Hop ricerca pattern",
        },
        {
            mode = { "n" },
            lhs = "f",
            rhs = [[<Cmd>lua require'hop'.hint_words({ current_line_only = true })<CR>]],
            options = { silent = true },
            description = "Hop inizio parola (linea corrente)",
        },
        {
            mode = { "n" },
            lhs = "F",
            rhs = [[<Cmd>lua require'hop'.hint_words({ current_line_only = true, hint_position = require'hop.hint'.HintPosition.END })<CR>]],
            options = { silent = true },
            description = "Hop fine parola (linea corrente)",
        },
        -- {
        --     mode = { "n"},
        --     lhs = "ò",
        --     rhs = [[<Cmd>lua require'hop'.hint_char2()<CR>]],
        --     options = {silent = true },
        --     description = "Easymotion all bat ask one char",
        -- },
        -- {
        --     mode = { "n"},
        --     lhs = "à",
        --     rhs = [[<Cmd>lua require'hop'.hint_patterns()<CR>]],
        --     options = {silent = true },
        --     description = "Easymotion all bat ask wat search",
        -- },
        -- {
        --     mode = { "n"},
        --     lhs = "ù",
        --     rhs = [[<Cmd>lua require'hop'.hint_lines_skip_whitespace()<CR>]],
        --     options = {silent = true },
        --     description = "Easymotion jump to line",
        -- },
    })
end

return M
