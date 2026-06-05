--[[
===============================================================================================
Plugin: workspace.vim
===============================================================================================
Description: Usa i tab come workspace stile i3: ogni tab ha la sua lista di buffer isolata
             (i buffer dei tab non attivi vengono messi a buflisted=false). Fornisce i comandi
             numerati WS / WSbmv e il back-forth tra due tab.
Status: Active
Author: ahmadie (fork di dosimple/workspace.vim, orig. Olzvoi Bayasgalan)
Repository: https://github.com/ahmadie/workspace.vim
Notes:
 - Caricamento lazy su VeryLazy.
 - E' il MOTORE dei workspace numerati; tabby fa la tabline visiva e usa a sua volta il comando WS.
 - I bind condivisi col gruppo <leader>w di tabby (wr, wn, w<Left>, w<Right>, wcc, wc.N) sono
   gestiti da tabby: qui restano solo le funzioni proprie di workspace.vim.
 - Known issue (README): con buflisted=false i buffer dei tab non attivi non si salvano in
   sessione; il workaround :tabo su VimLeavePre e' presente ma commentato in M.configs.
 - Sorgente molto vecchio (2018): alcuni bug sono stati corretti localmente in nvim-data/lazy
   (scoping di g:SessionLoad, guardie airline). Le patch NON sono versionate qui e saltano a
   un :Lazy update.
Keymaps (prefisso <leader>w = Workspace):
 - <leader>ws        → Switch back-forth tra gli ultimi due tab (WS_Backforth)
 - <leader>wp        → Stampa lo stato dei tab (WS_Line)
 - <leader>w1..w0    → Vai/crea il workspace .N (WS N)
 - <leader>wm1..wm0  → Sposta il buffer corrente nel workspace .N (WSbmv N)
===============================================================================================
--]]

-- NOTE:: Per funzionare devo usare il comand tcd C:\dir.... per avere la working directory relativa al tab

local M = {}

M.plugins = {
    ["workspace"] = {
        "ahmadie/workspace.vim",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["workspace"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["workspace"] = function()
        local utils = require("sphynx.utils")
        -- if you are using session (ex. startify) close all tabs before exist,
        -- otherwise opened buffers are not restored.
        -- utils.define_augroups {
        --     _workspace = {
        --         {
        --             event = "VimLeavePre",
        --             opts = {
        --                 pattern = "*",
        --                 command = [[silent! tabo]],
        --                 nested = true,
        --             },
        --         },
        --     }
        -- }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "w"

    -- NOTA: i bind condivisi con tabby (wr, wn, w<Left>, w<Right>, wcc, wc.N)
    -- sono gestiti da tabby.lua per evitare conflitti sul prefisso <leader>w.
    -- Qui restano solo le funzioni proprie di workspace.vim (WS / WSbmv / back-forth).
    wk.add({
        { "<leader>" .. prefix, group = "  Workspace" },
        { "<leader>" .. prefix .. "s", [[<Cmd>call WS_Backforth()<CR>]], desc = "Switch from two tab [Workspace]" },
        { "<leader>" .. prefix .. "p", [[<Cmd>echo WS_Line()<CR>]], desc = "Print the tab status [Workspace]" },
        { "<leader>" .. prefix .. "#", desc = "New tab or move exist tab .N [Workspace]" },
        { "<leader>" .. prefix .. "m", group = "󰆾 Move" },
        { "<leader>" .. prefix .. "m" .. "#", desc = "Move buffer to tab .N [Workspace]" },
    }, mapping.opt_mappping)

    -- New or go to if exist tab .N
    for i = 1, 10 do
        wk.add({
            { "<leader>" .. prefix .. tostring(i), [[<Cmd>WS ]] .. tostring(i) .. [[<CR>]], hidden = true },
        }, mapping.opt_mappping)
    end

    -- Move buffer to tab .N
    for i = 1, 10 do
        wk.add({
            { "<leader>" .. prefix .. "m" .. tostring(i), [[<Cmd>WSbmv ]] .. tostring(i) .. [[<CR>]], hidden = true },
        }, mapping.opt_mappping)
    end
end

return M
