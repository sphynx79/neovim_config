--[[
===============================================================================================
Plugin: kassio/neoterm
===============================================================================================
Description: Wrapper del terminale di Neovim, qui configurato per il workflow di debug Ruby con
             PRY. Permette di eseguire comandi in un terminale integrato (`:T`), inviare codice a
             un REPL e gestire breakpoint PRY dall'editor.
Status: Active
Author: Sphynx (configurazione) / kassio (plugin)
Repository: https://github.com/kassio/neoterm
Notes:
 - Workflow debug PRY: si inserisce `binding.pry` nel codice come interruzione, poi si avvia il
   programma con `:T ruby application.rb args*`. Dentro la sessione PRY si lancia qualsiasi
   comando pry.
 - Shell: `pwsh` (`g:neoterm_shell`); su Windows l'EOF è "\r" (`g:neoterm_eof`); REPL Ruby = `pry`
   (`g:neoterm_repl_ruby`).
 - Callback `before_new`: apre il terminale in split verticale se la finestra è larga >100
   colonne, altrimenti in split orizzontale (entrambi `botright`).
 - Callback `before_exec`: salva tutti i buffer (`wall`) prima di ogni `:T`.
 - `SetBreakPoint()`: invia a PRY un breakpoint sul file:riga correnti (`break path:line`).
 - Lazy-load su comandi `:T`, `:Tnew`, `:Topen`, `:Ttoggle`, `:TREPLSend*`.

Keymaps:
 - <leader>Ts   (visual) → invia la selezione al REPL (`TREPLSendSelection`)
 - <leader>Tl   (normal) → invia la riga al REPL (`TREPLSendLine`)
 - <localleader>nb (normal) → setta un breakpoint PRY su file:riga corrente
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["neoterm"] = {
        "kassio/neoterm",
        lazy = true,
        cmd = { "T", "Tnew", "Topen", "Ttoggle", "TREPLSendSelection", "TREPLSendLine", "TREPLSendFile" },
    },
}

M.setup = {
    ["neoterm"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["neoterm"] = function()
        vim.cmd([[
            let g:neoterm_callbacks = {}
            function! g:neoterm_callbacks.before_new()
            if winwidth('.') > 100
                let g:neoterm_default_mod = 'botright vertical'
            else
                let g:neoterm_default_mod = 'botright'
            end
            endfunction
            function! g:neoterm_callbacks.before_exec()
                wall
            endfunction
            let g:neoterm_shell = 'pwsh'

            if has("win32")
            let g:neoterm_eof = "\r"
            endif

            let g:neoterm_repl_ruby = 'pry'
            set shellquote= shellxquote=
            tnoremap <Esc> <C-\><C-n>
        ]])

        vim.cmd([[
            function! SetBreakPoint() abort
                let l:path_and_line = substitute(fnamemodify(expand("%"), ":~:."),"\\","/", "g") . ':' . line(".")
                echom "Set break Point " . l:path_and_line
                execute "T break " . l:path_and_line
            endfunction
            nnoremap <silent> <localleader>nb :<C-U>call SetBreakPoint()<CR>
        ]])
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").add({
        { "<leader>T", group = " Terminal" },
        { "<leader>Ts", [[<CMD>TREPLSendSelection<CR>]], mode = { "v" }, desc = "Send selection to term" },
        { "<leader>Tl", [[<CMD>TREPLSendLine<CR>]], mode = { "n" }, desc = "Send line to term" },
    })
end

return M
