--[[
===============================================================================================
Plugin: nvim-treesitter-textobjects
===============================================================================================
Description: Aggiunge text objects semantici basati su Tree-sitter per selezionare elementi
             strutturali del codice, come funzioni e classi, invece di usare solo text objects
             tradizionali basati su delimitatori o regex.
Status: Active
Author: nvim-treesitter
Repository: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
Notes:
 - Questa configurazione usa il branch `main`.
 - Richiede Tree-sitter correttamente attivo per il linguaggio corrente.
 - Le selezioni dipendono dalle query `textobjects.scm` disponibili per ogni linguaggio.
 - `lookahead = true` permette di agganciare automaticamente il prossimo text object valido.
 - `@parameter.outer` usa selezione charwise (`v`), mentre `@function.outer` usa linewise (`V`).
 - `include_surrounding_whitespace = false` evita di includere automaticamente spazi e righe
   adiacenti nella selezione.
 - `vim.g.no_plugin_maps = true` disabilita eventuali keymap automatiche del plugin, lasciando
   la gestione completa delle mappature alla configurazione custom.
Keymaps:
 - `af` → seleziona la funzione esterna (`@function.outer`)
 - `if` → seleziona il contenuto interno della funzione (`@function.inner`)
 - `ac` → seleziona la classe esterna (`@class.outer`)
 - `ic` → seleziona il contenuto interno della classe (`@class.inner`)
===============================================================================================
--]]

local M = {}

M.plugins = {
  ["nvim-treesitter-textobjects"] = {
     branch = "main",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}

M.setup = {
    ["nvim-treesitter-textobjects"] = function()
        vim.g.no_plugin_maps = true
        M.keybindings()
    end
}


M.configs = {
    ["nvim-treesitter-textobjects"] = function()
        require("nvim-treesitter-textobjects").setup {
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    -- ['@class.outer'] = '<c-v>', -- blockwise
                },

                include_surrounding_whitespace = false,
            },
        }
    end,
}

M.keybindings = function()
    local select = require("nvim-treesitter-textobjects.select")

    vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
    end)
end

return M
