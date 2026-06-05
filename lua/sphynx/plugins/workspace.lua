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
