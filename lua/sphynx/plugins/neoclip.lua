--[[
===============================================================================================
Plugin: nvim-neoclip.lua
===============================================================================================
Description: Clipboard manager per Neovim. Registra tutto ciò che viene yankato nella sessione
             e ne mantiene una cronologia consultabile da un picker (qui Telescope), da cui si
             può incollare o ripristinare in un registro a scelta.
Status: Active
Author: AckslD
Repository: https://github.com/AckslD/nvim-neoclip.lua
Notes:
 - Caricamento lazy su `event = { "TextYankPost" }`: il plugin si carica al primo yank. lazy.nvim
   ri-emette l'evento dopo il load, quindi anche il PRIMO yank della sessione viene catturato.
 - È un'estensione di **Telescope**: `setup()` registra solo l'autocmd di cattura; il picker si
   apre da una keymap definita in `telescope.lua` → `<leader>ty` (dropdown, initial_mode normal).
   `require("telescope").load_extension("neoclip")` viene chiamato qui nel config.
 - Settaggi rilevanti (gli altri valori coincidono con i default del plugin):
    - `history = 50`        → max 50 voci in cronologia (default plugin: 1000).
    - `enable_persistent_history = false` → la cronologia NON sopravvive alla chiusura di nvim
      (per renderla persistente servirebbe `sqlite.lua` + questa opzione a true).
    - `preview = true`      → anteprima della voce selezionata (utile per yank multiriga).
    - `default_register = '"'` → registro di default in cui incollare/ripristinare.
    - `on_paste = { set_reg = false }` → incollando dal picker NON popola anche il registro.
 - Macro: `enable_macro_history` è attivo di default → i macro registrati vengono salvati e
   sono consultabili con `:Telescope macroscope` (al momento senza keymap dedicata).
 - Il titolo dinamico dell'anteprima richiede `dynamic_preview_title = true` lato Telescope
   (impostato in `telescope.lua`).

Keymaps:
 - <leader>ty (in telescope.lua) → Apre il picker neoclip (yank ring)
 - Dentro il picker Telescope (default): <cr> seleziona, <c-p>/p incolla, <c-k>/P incolla dietro,
   <c-q>/q replay macro, <c-d>/d elimina voce, <c-e>/e modifica voce.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["neoclip"] = {
        "AckslD/nvim-neoclip.lua",
        lazy = true,
        event = { "TextYankPost" },
    },
}

M.configs = {
    ["neoclip"] = function()
        require("neoclip").setup({
            history = 50,
            enable_persistent_history = false,
            db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
            filter = nil,
            preview = true,
            default_register = '"',
            content_spec_column = false,
            on_paste = { set_reg = false },
            keys = {
                telescope = {
                    i = {
                        select = "<cr>",
                        paste = "<c-p>",
                        paste_behind = "<c-k>",
                        replay = "<c-q>",
                        delete = "<c-d>",
                        edit = "<c-e>",
                        custom = {},
                    },
                    n = {
                        select = "<cr>",
                        paste = "p",
                        paste_behind = "P",
                        replay = "q",
                        delete = "d",
                        edit = "e",
                        custom = {},
                    },
                },
            },
        })
        require("telescope").load_extension("neoclip")
    end,
}

return M
