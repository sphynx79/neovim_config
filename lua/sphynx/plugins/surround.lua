--[[
===============================================================================================
Plugin: nvim-surround
===============================================================================================
Description: Aggiunge, cambia e cancella coppie di delimitatori (virgolette, parentesi, tag
             HTML/XML, ecc.) attorno a un text-object, una motion o una selezione visuale.
Status: Active
Author: kylechui (Kyle Chui)
Repository: https://github.com/kylechui/nvim-surround
Notes:
 - Caricamento lazy su event = "VeryLazy".
 - move_cursor = "sticky": dopo l'operazione il cursore resta sul carattere su cui eri, non
   salta all'inizio dell'azione.
 - In Visual mode i delimitatori sono rimappati per circondare la selezione premendo
   direttamente il carattere (niente piu' "S" come prefisso): es. selezioni "prova" e premi
   " per ottenere "prova".
 - La rimappatura usa la mode "x" (solo Visual), non "v": cosi' la Select mode usata dagli
   snippet resta intatta.
 - Le parentesi producono la forma stretta, senza spazi interni: ( e ) danno entrambe
   (prova), non ( prova ). Stesso comportamento per [ ] e { }.
 - I mapping visual usano remap = true perche' "S" e' a sua volta un mapping di nvim-surround.
Keymaps:
 - Add/Change/Delete (default del plugin):
    ys{motion}{c}  → circonda il text-object   (es. ysiw" → "parola")
    cs{old}{new}   → cambia il delimitatore     (es. cs'"  → 'x' diventa "x")
    ds{c}          → cancella il delimitatore    (es. ds"   → toglie le virgolette)
 - Visual (custom, definiti in questa config): seleziona il testo e premi il delimitatore
    " ' `          → "sel" / 'sel' / `sel`
    ( )            → (sel)   [stretto, senza spazi]
    [ ]            → [sel]   [stretto, senza spazi]
    { }            → {sel}   [stretto, senza spazi]
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["surround"] = {
        "kylechui/nvim-surround",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["surround"] = function()
        require("nvim-surround").setup({
            move_cursor = "sticky", -- il cursore resta sul carattere su cui eri, non salta all'inizio dell'azione
        })

        -- Surround rapido in Visual mode: seleziona il testo e premi il
        -- delimitatore per circondarlo (es. viw poi " -> "prova").
        -- Le parentesi producono la forma stretta, senza spazi interni.
        local visual_surround = {
            ['"'] = '"',
            ["'"] = "'",
            ["`"] = "`",
            ["("] = ")", -- ( o ) -> (prova)  (stretto, niente spazi)
            [")"] = ")",
            ["["] = "]",
            ["]"] = "]",
            ["{"] = "}",
            ["}"] = "}",
        }
        for key, delim in pairs(visual_surround) do
            vim.keymap.set("x", key, "S" .. delim, {
                remap = true, -- 'S' e' il mapping di nvim-surround, serve la rimappatura
                desc = "Surround selezione con " .. key,
            })
        end
    end,
}

return M
