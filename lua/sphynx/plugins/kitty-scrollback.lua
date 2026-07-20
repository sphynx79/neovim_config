--[[
===============================================================================================
Plugin: mikesmithgh/kitty-scrollback.nvim
===============================================================================================
Description: Apre lo scrollback (la cronologia a schermo) del terminale Kitty dentro Neovim, per
             navigarlo, cercarci con i motion di Vim, copiare porzioni di output e riprendere/
             editare comandi passati prima di rilanciarli.
Status: Active (solo Linux)
Author: Sphynx (configurazione) / mikesmithgh (plugin)
Repository: https://github.com/mikesmithgh/kitty-scrollback.nvim
Notes:
 - Attivo SOLO su Linux "puro": `cond` replica la logica di is_linux (has("unix") ed esclude
   macunix e win32unix/MSYS2). Su Windows e macOS il plugin resta nel lockfile ma non si carica.
 - Requisiti: Neovim >= 0.10, Kitty >= 0.43.0.
 - Il plugin viene lanciato da Kitty tramite un kitten, quindi si carica sull'evento
   `User KittyScrollbackLaunch` (non serve aprirlo a mano da Neovim).
 - Setup lato Kitty (una volta, da fare in `~/.config/kitty/kitty.conf`):
       allow_remote_control socket-only
       listen_on unix:/tmp/kitty
       shell_integration enabled
   poi generare i kitten con `:KittyScrollbackGenerateKittens` e mappare in kitty.conf:
       map kitty_mod+h kitten kitty_scrollback_nvim.py
 - Diagnostica: `:KittyScrollbackCheckHealth`.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["kitty-scrollback"] = {
        "mikesmithgh/kitty-scrollback.nvim",
        lazy = true,
        cond = function()
            return (vim.fn.has("unix") == 1)
                and not (vim.fn.has("macunix") == 1)
                and not (vim.fn.has("win32unix") == 1)
        end,
        cmd = {
            "KittyScrollbackGenerateKittens",
            "KittyScrollbackCheckHealth",
            "KittyScrollbackGenerateCommandLineEditing",
        },
        event = { "User KittyScrollbackLaunch" },
    },
}

M.configs = {
    ["kitty-scrollback"] = function()
        require("kitty-scrollback").setup()
    end,
}

return M
