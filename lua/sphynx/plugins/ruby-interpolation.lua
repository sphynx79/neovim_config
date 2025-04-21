--[[
===============================================================================================
Plugin: vim-ruby-interpolation
===============================================================================================
Description: Aggiunge l'interpolazione delle stringhe Ruby (#{...}).
Status: Inactive
Author: p0deje
Repository: https://github.com/p0deje/vim-ruby-interpolation
Notes:
 - Questo plugin è spesso usato insieme a `vim-ruby`.
 - Può abilitare text objects specifici per l'interpolazione (es. i#, a#) se configurati.
Keymaps:
 - Nessuna mappatura chiave predefinita aggiunta direttamente da questo plugin.
===============================================================================================
--]]
--
local M = {}

M.plugins = {
    ["ruby_interpolation"] = {
        "p0deje/vim-ruby-interpolation",
        name = "ruby-interpolation",
        lazy = true,
        ft = {"ruby"}
    },
}

return M

