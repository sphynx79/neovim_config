-- NOTE:PLUGIN: neoterm.lua
-- DESCRIZIONE:
-- Avvia sessione di debug con PRY
-- OSSERVAZIONI:
-- Setto un'interuzzione nel codice con:
-- binding.pry
-- In Neovim avvio il Debug com il comando per chiamare l'avvio del programma
-- :T ruby application.rb args*
-- Ora sono dentro la sessione di Debug con PRY, posso lanciare qualsiasi comandi pry da quindi
-- Per settare un breakpoint nel codice ho creato una funzione SetBreakPoint, che invia a PRY il nome del
-- file e la riga e setta il breakpoint
-- per settarlo ho settato la map <localleader>nb

local M = {}

M.plugins = {
    ["neoterm"] = {
        "kassio/neoterm",
        lazy = true,
        cmd = {"T"},
    },
}

M.setup = {
    ["neoterm"] = function()
        M.keybindings()
    end
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
                echom "Set break Point" . l:path_and_line
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

