--[[
===============================================================================================
Plugin: oklch-color-picker.nvim
===============================================================================================
Description: Color picker grafico nello spazio percettivo Oklch (lightness/chroma/hue) unito a
             un highlighter asincrono dei colori nel buffer. Permette di selezionare/modificare
             un colore sotto il cursore con una UI dedicata e di evidenziare i colori nel testo.
Status: Active
Author: eero-lehtinen
Repository: https://github.com/eero-lehtinen/oklch-color-picker.nvim
Notes:
 - Backend: applicazione standalone in **Rust** (picker + libreria di parsing) scaricata
   automaticamente (`auto_download`, default) dalle release alla prima inizializzazione.
   Binari prebuilt per Windows/Linux/macOS, in cache dopo il primo download.
 - **Highlighting disattivato all'avvio** (`highlight.enabled = false`): l'evidenziazione
   automatica dei colori NON parte da sola, si attiva on-demand con `<leader>ce`/`<leader>ct`.
 - `highlight.enabled_lsps` limitato a `tailwindcss`, `cssls`, `css_variables`: solo questi
   LSP sono autorizzati a fornire colori (lista conservativa per le performance; con
   `enabled_lsps = true` si abiliterebbero tutti gli LSP).
 - Formati riconosciuti: hex (`#RGB`/`#RRGGBB`/...), CSS `rgb()`/`hsl()`/`oklch()`,
   hex literal (`0x...`), Tailwind (`bg-red-800`), numeri tra parentesi (`vec3(..)`).
 - Highlighting **asincrono** e incrementale (solo righe visibili/modificate): pensato per
   non introdurre lag, tra i più rapidi nel benchmark della doc upstream.
 - Comando `:ColorPickOklch` equivalente a `pick_under_cursor()`.
 - Caricamento: `event = "VeryLazy"` (dopo l'avvio della UI).

Keymaps (Prefisso principale: <leader>c " Colors"):
 - <leader>ce → Abilita l'highlighting dei colori (highlight.enable)
 - <leader>ct → Toggle dell'highlighting (highlight.toggle)
 - <leader>cd → Disabilita l'highlighting (highlight.disable)
 - <leader>cp → Apre il color picker sul colore sotto il cursore (pick_under_cursor)

TODO:
 - [ ] Valutare un lazy-loading on-demand (`keys`/`cmd`) al posto di `event = "VeryLazy"`:
       con `highlight.enabled = false` il plugin (e il download del binario Rust) si
       inizializza all'avvio anche senza usarlo. Attenzione: le keymap sono definite via
       which-key in `M.setup`/`init`, quindi il passaggio a `keys` va verificato per non
       rompere i mapping (le keymap chiamano `require("oklch-color-picker")...`).
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["color"] = {
        "eero-lehtinen/oklch-color-picker.nvim",
        event = "VeryLazy",
    },
}

M.setup = {
    ["color"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["color"] = function()
        require("oklch-color-picker").setup({
            highlight = {
                enabled = false,
                -- List of LSP clients that are allowed to highlight colors:
                -- By default, only fairly performant and useful LSPs are enabled.
                -- Set `enabled_lsps = true` to enable all LSPs anyways.
                enabled_lsps = { "tailwindcss", "cssls", "css_variables" },
            },
        })
    end,
}

M.keybindings = function()
    local wk = require("which-key")

    wk.add({
        { "<leader>c", group = " Colors" },
        { "<leader>ce", [[<Cmd>lua require("oklch-color-picker").highlight.enable()<CR>]], desc = "Enable" },
        { "<leader>ct", [[<Cmd>lua require("oklch-color-picker").highlight.toggle()<CR>]], desc = "Toggle" },
        { "<leader>cd", [[<Cmd>lua require("oklch-color-picker").highlight.disable()<CR>]], desc = "Disable" },
        { "<leader>cp", [[<Cmd>lua require('oklch-color-picker').pick_under_cursor()<CR>]], desc = "Pick color" },
    })
end

return M
