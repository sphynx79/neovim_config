--[[
===============================================================================================
Plugin: colorful-winsep.nvim
===============================================================================================
Description: Colora il bordo (separatore) della finestra attiva, come fa tmux con i suoi pane,
             per distinguere a colpo d'occhio quale split ha il focus.
Status: Active
Author: nvim-zh
Repository: https://github.com/nvim-zh/colorful-winsep.nvim
Notes:
 - Richiede Neovim 0.11.3+ e una Nerd Font (qui nvim e' 0.12.2, ok).
 - Caricamento lazy su evento WinLeave: il plugin serve solo con due o piu' finestre, e
   WinLeave scatta appena si crea una split (il focus lascia la finestra corrente).
 - excluded_ft adattato ai filetype reali del setup: il default del plugin cita "packer" e
   "mason" che qui non esistono. Esclusi NvimTree, aerial, trouble, lazy, TelescopePrompt
   cosi' il bordo colorato non compare sulle finestre-utility/sidebar.
 - highlight = "#81A1C1" (Nord frost): coerente col tema nordfox; passando una stringa il
   plugin la usa come fg e prende il bg dal gruppo "Normal" (vedi :h hl-Normal).
 - animate.enabled = "shift": animazione di scorrimento del bordo (default del plugin).
 - indicator_for_2wins.position = "center": con sole due finestre mostra un indicatore al
   centro del separatore, dove il solo bordo sarebbe ambiguo.
Keymaps:
 - (nessuna keymap) il plugin si controlla via comandi :Winsep
Commands:
 - :Winsep enable        → attiva il plugin
 - :Winsep disable       → disattiva il plugin
 - :Winsep toggle        → attiva/disattiva il plugin
TODO:
 - [ ] Valutare l'effetto marquee multicolore (opzione colors) con palette Nord Aurora
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["colorful-winsep"] = {
        "nvim-zh/colorful-winsep.nvim",
        lazy = true,
        event = { "WinLeave" },
    },
}

M.configs = {
    ["colorful-winsep"] = function()
        require("colorful-winsep").setup({
            border = "bold", -- "single" | "rounded" | "bold" | "double"
            excluded_ft = { "TelescopePrompt", "NvimTree", "aerial", "trouble", "lazy" },
            highlight = "#81A1C1", -- Nord frost: usato come fg, bg ereditato da "Normal"
            animate = {
                enabled = false, -- "shift" | "progressive" | false
            },
            indicator_for_2wins = {
                position = false, -- false | "center" | "start" | "end" | "both"
            },
        })

        -- Fix crash con maximize.nvim: il restore di sessione (mksession/source)
        -- distrugge i buffer scratch dei separatori e silenzia gli eventi, quindi
        -- il guard SessionLoadPost del plugin non scatta. vertical_init/horizontal_init
        -- sono gli unici metodi che toccano il buffer senza controllarne la validita':
        -- li avvolgo per ricrearlo al volo se morto.
        local Separator = require("colorful-winsep.separator")
        local function ensure_buf(sep)
            if not vim.api.nvim_buf_is_valid(sep.buffer) then
                sep.buffer = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_set_option_value("buftype", "nofile", { buf = sep.buffer })
            end
        end
        local orig_vertical = Separator.vertical_init
        function Separator:vertical_init(height)
            ensure_buf(self)
            return orig_vertical(self, height)
        end
        local orig_horizontal = Separator.horizontal_init
        function Separator:horizontal_init(width)
            ensure_buf(self)
            return orig_horizontal(self, width)
        end
    end,
}

return M
