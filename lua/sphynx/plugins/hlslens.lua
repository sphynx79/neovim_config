--[[
===============================================================================================
Plugin: kevinhwang91/nvim-hlslens
===============================================================================================
Description: Migliora l'esperienza di ricerca di Neovim mostrando, accanto a ogni corrispondenza,
             un "lens" in virtual text con l'indice della corrispondenza e il totale (es. [2/7]),
             più un indicatore di direzione (▲/▼). Rende immediato capire "a quale risultato sono"
             e "quanti ne restano" senza guardare la command line.
Status: Active
Author: Sphynx (configurazione) / kevinhwang91 (plugin)
Repository: https://github.com/kevinhwang91/nvim-hlslens
Notes:
 - Caricato a `VeryLazy`; i keymap di ricerca sono registrati allo startup (M.setup → init) e
   ognuno chiama `require('hlslens').start()` per riattivare il lens dopo lo spostamento.
 - Impostazioni (`require("hlslens").setup{}`):
    - `calm_down = true`        → quando il cursore esce dalla corrispondenza corrente l'highlight
                                  di ricerca viene ripulito (come :noh), riducendo il rumore visivo.
    - `nearest_only = false`    → il lens è mostrato su TUTTE le corrispondenze visibili, non solo
                                  sulla più vicina al cursore.
    - `nearest_float_when = "never"` → mai floating window per la corrispondenza più vicina: il
                                  conteggio è sempre virtual text inline.
    - `override_lens(...)`      → formatter custom del testo virtuale: costruisce l'indicatore di
                                  direzione (▲/▼ in base a `v:searchforward` e all'offset r_idx) e
                                  il testo `[idx/tot]`. Usa l'highlight `HlSearchLensNear` per la
                                  corrispondenza corrente e `HlSearchLens` per le altre.

Keymaps (Normal mode):
 - n / N        → vai alla prossima/precedente corrispondenza, avvia il lens e apre il fold
                  (solo se presente: guardia `foldlevel('.') > 0`).
 - * / #        → cerca la parola sotto il cursore (con word boundary) e vai avanti/indietro.
 - g* / g#      → come * / # ma senza word boundary (match anche come sottostringa).
   Tutti i keymap aprono il fold della corrispondenza in modo protetto (no errore E490).
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["hlslens"] = {
        "kevinhwang91/nvim-hlslens",
        lazy = true,
        name = "hlslens",
        event = "VeryLazy",
    },
}

M.setup = {
    ["hlslens"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["hlslens"] = function()
        require("hlslens").setup({
            calm_down = true,
            nearest_only = false,
            nearest_float_when = "never",
            override_lens = function(render, plist, nearest, idx, r_idx)
                local sfw = vim.v.searchforward == 1
                local indicator, text, chunks
                local abs_r_idx = math.abs(r_idx)
                if abs_r_idx > 1 then
                    indicator = ("%d%s"):format(abs_r_idx, sfw ~= (r_idx > 1) and "▲" or "▼")
                elseif abs_r_idx == 1 then
                    indicator = sfw ~= (r_idx == 1) and "▲" or "▼"
                else
                    indicator = ""
                end

                local lnum, col = unpack(plist[idx])
                if nearest then
                    local cnt = #plist
                    if indicator ~= "" then
                        text = ("[%s %d/%d]"):format(indicator, idx, cnt)
                    else
                        text = ("[%d/%d]"):format(idx, cnt)
                    end
                    chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
                else
                    text = ("[%s %d]"):format(indicator, idx)
                    chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
                end
                render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
            end,
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n" },
            lhs = "n",
            rhs = [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Move next occurrence in searched",
        },
        {
            mode = { "n" },
            lhs = "N",
            rhs = [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Move previous occurrence in searched",
        },
        {
            mode = { "n" },
            lhs = "*",
            rhs = [[*<Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            -- rhs = [[*<Cmd>lua require('hlslens').start()<CR><Cmd>silent !foldopen<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move next",
        },
        {
            mode = { "n" },
            lhs = "#",
            rhs = [[#<Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move previous",
        },
        {
            mode = { "n" },
            lhs = "g*",
            rhs = [[g*<Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move next",
        },
        {
            mode = { "n" },
            lhs = "g#",
            rhs = [[g#<Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move previous",
        },
    })
end

return M
