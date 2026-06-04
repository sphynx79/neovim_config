--[[
===============================================================================================
Plugin: karb94/neoscroll.nvim
===============================================================================================
Description: Scrolling fluido (animato) per Neovim. Le mappature di default sono disabilitate
             (`mappings = {}`); lo smooth scroll è esposto su keymap custom <localleader> + frecce,
             con ampiezza e durata crescenti in base al numero di ripetizioni del tasto.
Status: Active
Author: Sphynx (configurazione) / karb94 (plugin)
Repository: https://github.com/karb94/neoscroll.nvim
Notes:
 - `easing = "quadratic"` è il default globale; le keymap custom usano "quintic".
 - `cursor_scrolls_alone = false`: il cursore non continua a scorrere se la finestra non può.
 - Performance Mode (disabilita Tree-sitter/syntax durante l'animazione) attivo SOLO sui file
   lunghi: globale OFF + autocmd che setta `b:neoscroll_performance_mode` sui buffer > 1000 righe.
   Il flag buffer-local accende il PM solo se il globale è OFF (scroll.lua: `vim.b... or vim.g...`).
 - Lazy-load implicito: il plugin si carica al primo `require("neoscroll")` dentro le keymap.

Keymaps (normal/visual/select):
 - <localleader><Up> / <Up><Up> / <Up>x3     → scroll su  10% / 30% / 90% (durate 200/590/1000ms)
 - <localleader><Down> / <Down><Down> / x3   → scroll giù 10% / 30% / 90%
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["neoscroll"] = {
        "karb94/neoscroll.nvim",
        lazy = true,
    },
}

M.setup = {
    ["neoscroll"] = function()
        M.keybindings()
        -- Performance Mode solo sui file lunghi (>1000 righe).
        -- Il flag buffer-local accende il PM solo se il globale è OFF (scroll.lua: `vim.b... or vim.g...`).
        vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost" }, {
            group = vim.api.nvim_create_augroup("NeoscrollPerfMode", { clear = true }),
            callback = function(args)
                if vim.api.nvim_buf_line_count(args.buf) > 1000 then
                    vim.b[args.buf].neoscroll_performance_mode = true
                end
            end,
            desc = "Neoscroll: performance mode solo su file > 1000 righe",
        })
    end,
}

M.configs = {
    ["neoscroll"] = function()
        local neoscroll = require("neoscroll")
        neoscroll.setup({
            mappings = {},
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = true, -- Stop at <EOF> when scrolling downwards
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            use_local_scrolloff = false,
            cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing = "quadratic", -- Default easing function
            performance_mode = false, -- globale OFF: il PM si attiva per-buffer solo sui file lunghi (vedi autocmd in M.setup)
            duration_multiplier = 1.0, -- Global duration multiplier
            pre_hook = nil, -- Function to run before the scrolling animation starts
            post_hook = nil, -- Function to run after the scrolling animation ends
            ignored_events = { -- Events ignored while scrolling
                "WinScrolled",
                "CursorMoved",
            },
        })
    end,
}

M.keybindings = function()
    local keymap = {
        ["<localleader><Up>"] = function()
            require("neoscroll").scroll(-0.1, { move_cursor = false, duration = 200, easing = "quintic" })
        end,
        ["<localleader><Up><Up>"] = function()
            require("neoscroll").scroll(-0.30, { move_cursor = false, duration = 590, easing = "quintic" })
        end,
        ["<localleader><Up><Up><Up>"] = function()
            require("neoscroll").scroll(-0.90, { move_cursor = false, duration = 1000, easing = "quintic" })
        end,
        ["<localleader><Down>"] = function()
            require("neoscroll").scroll(0.1, { move_cursor = false, duration = 200, easing = "quintic" })
        end,
        ["<localleader><Down><Down>"] = function()
            require("neoscroll").scroll(0.30, { move_cursor = false, duration = 590, easing = "quintic" })
        end,
        ["<localleader><Down><Down><Down>"] = function()
            require("neoscroll").scroll(0.90, { move_cursor = false, duration = 1000, easing = "quintic" })
        end,
    }

    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
    end
end

return M
