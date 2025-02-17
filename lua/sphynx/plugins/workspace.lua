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
        utils.define_augroups {
            _workspace = {
                {
                    event = "VimLeavePre",
                    opts = {
                        pattern = "*",
                        command = [[silent! tabo]],
                        nested = true,
                    },
                },
            }
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    wk.register({
        w = {
            name = "  Workspace",
            ["s"] = {[[<Cmd>call WS_Backforth()<CR>]], "Switch from two tab [Workspace]"},
            ["#"] = "New tab or move exist tab .N [Workspace]",
            ["p"] = {[[<Cmd>echo WS_Line()<CR>]], "Print the tab status [Workspace]"},
            ["<Left>"]  = {[[<Cmd>tabprevious<CR>]], "Tab left"},
            ["<Right>"] = {[[<Cmd>tabnext<CR>]], "Tab right"},
            ["n"] = {[[<Cmd>tabnew<CR>]], "Tab new"},
            ["m"]       = {
                name = "󰆾 Move",
                ["#"] = "Move buffer to tab .N [Workspace]",
            },
            ["c"]       = {
                name = " Close",
                ["c"] = { [[<Cmd>lua require('sphynx.utils').closeAllBufs('closeTab')<CR>]], "Close current tab [utils=>init.lua]" },
                ["#"] = "Close tab .N [Workspace]",
            },
        },
    }, mapping.opt_plugin)


    -- New tab .N
    for i = 1, 10 do
        wk.register({
            w = {
                name = " Workspace",
                [tostring(i)] =  { [[<Cmd>WS ]] .. tostring(i) .. [[<CR>]], "which_key_ignore" },
            }
        }, mapping.opt_plugin)
    end

    -- Move buffer to tab .N
    for i = 1, 10 do
        wk.register({
            w = {
                name = "  Workspace",
                ["m"] = {
                    name = " Move",
                    [tostring(i)] = { [[<Cmd>WSbmv ]] .. tostring(i) .. [[<CR>]], "which_key_ignore" },
                }
            }
        }, mapping.opt_plugin)
    end

    -- Close tab .N
    for i = 1, 10 do
        wk.register({
            w = {
                name = "  Workspace",
                ["c"] = {
                    name = " Close",
                    [tostring(i)] = { [[<Cmd>lua vim.cmd("WS ]] .. tostring(i) .. [[") require('sphynx.utils').closeAllBufs('closeTab')<CR>]], "which_key_ignore" },
                }
            }
        }, mapping.opt_plugin)
    end
end

return M
