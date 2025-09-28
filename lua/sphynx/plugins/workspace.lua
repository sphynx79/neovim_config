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

    wk.add({
        { "<leader>" .. prefix, group = "  Workspace" },
        { "<leader>" .. prefix .. "s", [[<Cmd>call WS_Backforth()<CR>]], desc = "Switch from two tab [Workspace]" },
        { "<leader>" .. prefix .. "p", [[<Cmd>echo WS_Line()<CR>]], desc = "Print the tab status [Workspace]" },
        { "<leader>" .. prefix .. "<Left>", [[<Cmd>tabprevious<CR>]], desc = "Tab left [Workspace]" },
        { "<leader>" .. prefix .. "<Right>", [[<Cmd>tabnext<CR>]], desc = "Tab right [Workspace]" },
        { "<leader>" .. prefix .. "r", [[<Cmd>TabRename<CR>]], desc = "Rename current Tab [ui/tabbufline/lazyload]" },
        { "<leader>" .. prefix .. "n", [[<Cmd>tabnew<CR>]], desc = "Tab new [Workspace]" },
        { "<leader>" .. prefix .. "#", desc = "New tab or move exist tab .N [Workspace]" },
        { "<leader>" .. prefix .. "m", group = "󰆾 Move" },
        { "<leader>" .. prefix .. "m" .. "#", desc = "Move buffer to tab .N [Workspace]" },
        { "<leader>" .. prefix .. "c", group = " Close [Workspace]" },
        { "<leader>" .. prefix .. "c" .. "c", [[<Cmd>lua require('sphynx.utils').closeAllBufs('closeTab')<CR>]], desc = "Close current tab [utils=>init.lua]" },
        { "<leader>" .. prefix .. "c" .. "#", desc = "Close tab .N [Workspace]" },
    }, mapping.opt_mappping)

    -- New or go to if exist tab .N
    for i = 1, 10 do
        wk.add({
            { "<leader>" .. prefix .. tostring(i),  [[<Cmd>WS ]] .. tostring(i) .. [[<CR>]], hidden = true },
        }, mapping.opt_mappping)
    end

    -- Move buffer to tab .N
    for i = 1, 10 do
        wk.add({
            { "<leader>" .. prefix .. "m" .. tostring(i),  [[<Cmd>WSbmv ]] .. tostring(i) .. [[<CR>]], hidden = true },
        }, mapping.opt_mappping)
    end

    -- Close tab .N
    for i = 1, 10 do
        wk.add({
            { "<leader>" .. prefix .. "c" .. tostring(i),  [[<Cmd>lua vim.cmd("WS ]] .. tostring(i) .. [[") require('sphynx.utils').closeAllBufs('closeTab')<CR>]], hidden = true },
        }, mapping.opt_mappping)
    end
end

return M
