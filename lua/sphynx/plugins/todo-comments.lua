--[[
===============================================================================================
Plugin: todo-comments.nvim
===============================================================================================
Description: Evidenzia e permette di cercare i commenti-promemoria (TODO, FIX, HACK, BUG,
             PERF, NOTE, ...) nel codice, con segni nel gutter, colori e liste quickfix/
             Trouble/Telescope.
Status: Active
Author: folke
Repository: https://github.com/folke/todo-comments.nvim
Notes:
 - Caricamento lazy sugli eventi di file (BufReadPost/BufNewFile): l'highlight e' pronto
   gia' sul primo file aperto, e il plugin non si carica su buffer non-file.
 - Dipende da plenary.nvim (usato dalla ricerca ripgrep e dai comandi Todo*).
 - merge_keywords = true: le keyword custom si fondono coi default, quindi TEST
   (TESTING/PASSED/FAILED) e' ereditato senza ridefinirlo.
 - highlight.comments_only = true: usa TreeSitter per evidenziare solo dentro i commenti;
   se manca il parser TS del filetype fa fallback all'intera riga.
 - highlight.multiline = false: niente todo multiriga (meno rievaluazione a ogni modifica).
 - colors.error usa DiagnosticError (nomenclatura moderna, non LspDiagnosticsDefault*).
 - Ricerca via ripgrep (search.command = "rg").
Keymaps:
 - <leader>xq            → TodoQuickFix   (lista todo in quickfix)
 - <leader>xx            → TodoTrouble    (lista todo in Trouble)
 - <leader>xt            → TodoTelescope  (ricerca todo con Telescope)
 - <leader>x<Down> / <Up> → jump al todo successivo / precedente
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["todo-comments"] = {
        "folke/todo-comments.nvim",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}

M.setup = {
    ["todo-comments"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["todo-comments"] = function()
        require("todo-comments").setup({
            signs = true, -- show icons in the signs column
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
            },
            merge_keywords = true, -- unisce le keyword custom coi default: eredita TEST (TESTING/PASSED/FAILED)
            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = false,
                before = "", -- "fg" or "bg" or empty
                keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide/wide_bg come bg ma evidenzia anche i caratteri attorno; wide_fg idem ma con fg)
                after = "", -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlighting (vim regex)
                comments_only = true, -- usa treesitter per limitare il match ai soli commenti
            },
            -- list of named colors where we try to extract the guifg from the
            -- list of hilight groups or use the hex color if hl not found as a fallback
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>x"

    wk.add({
        -- Gruppo principale Todo-comment
        { prefix, group = " Todo" },
        { prefix .. "q", [[<Cmd>TodoQuickFix<CR>]], desc = "todo quickfix" },
        { prefix .. "x", [[<Cmd>TodoTrouble<CR>]], desc = "todo trouble" },
        { prefix .. "t", [[<Cmd>TodoTelescope<CR>]], desc = "todo telescope" },
        -- Jump tra i todo con le frecce
        { prefix .. "<Down>", [[<Cmd>lua require("todo-comments").jump_next()<CR>]], desc = "next todo comment" },
        { prefix .. "<Up>", [[<Cmd>lua require("todo-comments").jump_prev()<CR>]], desc = "prev todo comment" },
    }, mapping.opt_mappping)
end

return M
