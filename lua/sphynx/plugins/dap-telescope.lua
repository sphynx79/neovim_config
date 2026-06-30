--[[
===============================================================================================
Plugin: telescope-dap.nvim
===============================================================================================
Description: Integrazione tra nvim-dap e Telescope: espone comandi, configurazioni,
             breakpoint, frame e variabili del debugger tramite il selettore di Telescope.
Status: Active
Author: nvim-telescope
Repository: https://github.com/nvim-telescope/telescope-dap.nvim
Dependencies:
 - telescope.nvim: l'estensione "dap" viene caricata con telescope.load_extension("dap")
 - nvim-dap: fornisce i dati (comandi, configurazioni, breakpoint, frame, variabili)
Notes:
 - Caricamento lazy; le keybindings sono registrate via which-key (gruppo <leader>d Debug).
 - In M.configs l'estensione "dap" viene caricata con telescope.load_extension("dap"),
   protetta da un pcall su telescope.
Keymaps (<leader>d = Debug):
 - <leader>de → Commands         - <leader>df → Configurations
 - <leader>dl → List breakpoints - <leader>dm → Frames
 - <leader>dv → Variables
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["telescope_dap"] = {
        "nvim-telescope/telescope-dap.nvim",
        name = "telescope-dap",
        lazy = true,
    },
}

M.setup = {
    ["telescope_dap"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["telescope_dap"] = function()
        local ok, telescope = pcall(require, "telescope")
        if ok then
            telescope.load_extension("dap")
        end
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>d"

    wk.add({
        { prefix .. "e", '<Cmd>lua require"telescope".extensions.dap.commands{}<CR>', desc = "Commands" },
        { prefix .. "f", '<Cmd>lua require"telescope".extensions.dap.configurations{}<CR>', desc = "Configurations" },
        {
            prefix .. "l",
            '<Cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',
            desc = "List breakpoints",
        },
        { prefix .. "m", '<Cmd>lua require"telescope".extensions.dap.frames{}<CR>', desc = "Frames" },
        { prefix .. "v", '<Cmd>lua require"telescope".extensions.dap.variables{}<CR>', desc = "Variables" },
    }, mapping.opt_mappping)
end

return M
