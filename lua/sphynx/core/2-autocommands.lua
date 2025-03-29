local utils = require("sphynx.utils")

utils.define_augroups {
    _general = {
        {
            event = {"VimEnter"},
            opts = {
                pattern = "*",
                callback = function() vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h")) end,
                desc = "When open Neovim with file set current dir to file",
            },
        },
        {
            event = {"VimEnter", "DirChangedPre"},
            opts = {
                pattern = "*",
                callback = utils.set_shell_title,
                desc = "Set shell title",
            },
        },
        {
            event = {"BufEnter", "CursorHold", "CursorHoldI", "FocusGained"},
            opts = {
                pattern = "*",
                callback = utils.check_time,
                desc = "Check time",
            },
        },
        {
            event = "TextYankPost",
            opts = {
                pattern = "*",
                callback = function() vim.highlight.on_yank({higroup="IncSearch", timeout=1000, on_visual=true}) end,
                desc = "Highlight on yank",
            },
        },
        {
            event = "BufReadPost",
            opts = {
                pattern = "*",
                callback = function() vim.cmd [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] end,
                desc = "Go to last loc when opening a buffer",
            },
        },
        {
            event = "QuickFixCmdPost",
            opts = {
                pattern = "*",
                callback = function() vim.cmd('copen | wincmd J') end,
                desc = "Open quickfix bottom",
            },
        },
    },
    _filetype_setting = {
        {
            event = "filetype",
            opts = {
                pattern = "json",
                command = [[syntax match comment +\/\/.\+$+ | setlocal conceallevel=0]],
                desc = "Setting for json file",
            },
        },
        {
            event = {"BufEnter", "BufFilePost"},
            opts = {
                pattern = "*.ahk",
                callback = function() vim.api.nvim_set_option_value("commentstring", "; %s", { buf = 0 }) end,
                desc = "Setting ",
            },
        },
    },
    _options = {
        {
            event = "BufWritePost",
            opts = {
                pattern = "1-settings.lua",
                callback = reload_options,
                desc = "Reload config nvim",
            },
        },
    },
}

if sphynx.config.cursorline then
    utils.define_augroups {
        _cursorline = {
            {
                event = {"InsertLeave", "WinEnter"},
                opts = {
                    pattern = "*",
                    command = [[set cursorline]],
                    nested = true,
                    desc = "Enable cursorline",
                },
            },
            {
                event = {"InsertEnter", "WinLeave"},
                opts = {
                    pattern = "*",
                    command = [[set nocursorline]],
                    nested = true,
                    desc = "Disable cursorline",
                },
            }
        },
    }
end

if sphynx.config.auto_save_buffer then
    utils.define_augroups {
        _autosave = {
            {
                event = "FocusLost",
                opts = {
                    pattern = "*",
                    command = [[silent! wall]],
                    nested = true,
                    desc = "Save file automatic",
                },
            }
        },
    }
end
