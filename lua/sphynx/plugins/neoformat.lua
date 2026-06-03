--[[
===============================================================================================
Plugin: neoformat
===============================================================================================
Description: Formattatore di codice multi-linguaggio. Esegue il formatter configurato per il
             filetype corrente leggendo i dati dal buffer (non serve salvare con `:w`) e, in
             caso di successo, aggiorna il buffer mantenendo marks e jumps. Se un formatter
             fallisce, prova il successivo definito per quel filetype.
Status: Active
Author: sbdchd
Repository: https://github.com/sbdchd/neoformat
Notes:
 - Caricamento lazy: `lazy = true` + `cmd = { "Neoformat" }`, il plugin si carica solo al
   primo `:Neoformat` (le keymap <F8> lo invocano, quindi fungono da trigger).
 - Le `vim.g.neoformat_*` sono impostate in `M.setup`/`init` (eseguito all'avvio) perché
   il plugin le legge al caricamento.
 - Opzioni globali:
    - `only_msg_on_error = 1` → messaggio solo in caso di errore (meno rumore a ogni format).
    - `basic_format_trim = 1` → rimuove il trailing whitespace per i filetype SENZA formatter
      dedicato (rimpiazza il plugin `spaceless`, ora disabilitato). NB: agisce solo quando
      lanci `:Neoformat`/<F8>, NON automaticamente al salvataggio come faceva spaceless.
 - Formatter configurati per filetype:
    - **TypeScript** → `tsfmt`            (`g:neoformat_enabled_typescript`)
    - **sh / bash**  → `shfmt.exe` via stdin, args `-i 4 -ci -bn -sr`:
        -i 4 = indent 4 spazi, -ci = indenta i case di switch, -bn = operatori binari a
        inizio riga, -sr = spazio dopo redirect. La config è duplicata su `sh` e `bash`
        perche' Neovim classifica gli script come `sh` o `bash` a seconda dello shebang.
 - Formattazione di una selezione visuale: `:Neoformat` su selezione, o `:Neoformat! <ft>`
   per forzare un filetype diverso. Per formattare al salvataggio si usa `undojoin | Neoformat`
   in un autocmd BufWritePre (vedi doc, sezione undo-history).

Keymaps:
 - <F8> (normal)  → Formatta l'intero buffer (:Neoformat)
 - <F8> (visual)  → Formatta la selezione e ripristina la selezione (:Neoformat poi gv)

TODO:
 - [ ] Valutare prettier/vim-prettier per alcuni filetype (vedi TODO inline in M.plugins).
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["neoformat"] = {
        "sbdchd/neoformat",
        lazy = true,
        cmd = { "Neoformat" },
        -- TODO: vedere se per alcuni file usare prettier/vim-prettier vedere il file config che adesso lo ho disabilitato
    },
}

M.setup = {
    ["neoformat"] = function()
        -- Opzioni globali
        vim.g.neoformat_only_msg_on_error = 1
        vim.g.neoformat_basic_format_trim = 1

        vim.g.neoformat_enabled_typescript = { "tsfmt" }

        -- Bash/shell: formatta con shfmt
        -- Neovim puo' classificare i file .sh come filetype "sh" oppure "bash"
        -- (a seconda dello shebang): definiamo la config per entrambi.
        local shfmt = {
            exe = "shfmt.exe",
            args = { "-i", "4", "-ci", "-bn", "-sr" },
            stdin = 1,
        }
        vim.g.neoformat_sh_shfmt = shfmt
        vim.g.neoformat_bash_shfmt = shfmt
        vim.g.neoformat_enabled_sh = { "shfmt" }
        vim.g.neoformat_enabled_bash = { "shfmt" }

        M.keybindings()
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n" },
            lhs = "<F8>",
            rhs = [[<Cmd>Neoformat<CR>]],
            options = { silent = true },
            description = "Format code",
        },
        {
            mode = { "v" },
            lhs = "<F8>",
            rhs = [[<Cmd>Neoformat<CR>gv]],
            options = { silent = true },
            description = "Format code",
        },
    })
end

return M
