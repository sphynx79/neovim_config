--[[
===============================================================================================
Plugin: maximize.nvim
===============================================================================================
Description: Massimizza/ripristina la finestra (split) corrente con un toggle, nascondendo
             temporaneamente gli altri split e ripristinando il layout al ritorno.
Status: Active
Author: declancm
Repository: https://github.com/declancm/maximize.nvim
Notes:
 - Caricamento lazy: il plugin si carica al primo require('maximize') da una keymap.
 - Integrazioni configurate: nvim-tree abilitata; aerial e nvim-dap-ui disabilitate.
 - La keymap "wM" si aggancia al gruppo "w" = Window definito in core/5-mapping.lua
   (coerente con wc/wr*/wn*/wm* per la gestione delle finestre; <leader>w resta Workspace).
Keymaps:
 - wM → toggle massimizzazione finestra (require('maximize').toggle())
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["maximizer"] = {
        "declancm/maximize.nvim",
        lazy = true,
    },
}

M.setup = {
    ["maximizer"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["maximizer"] = function()
        require("maximize").setup({
            plugins = {
                aerial = { enable = false }, -- enable aerial.nvim integration
                dapui = { enable = false }, -- enable nvim-dap-ui integration
                tree = { enable = true }, -- enable nvim-tree.lua integration
            },
        })
    end,
}

M.keybindings = function()
    require("which-key").add({
        { "w", group = "󰆏 Window" },
        { "wM", [[<CMD>lua require('maximize').toggle()<CR>]], desc = "Maximize [maximize.nvim]" },
    })
end

return M
