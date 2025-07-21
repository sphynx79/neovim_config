--[[
===============================================================================================
Plugin: mhinz/vim-grepper
===============================================================================================
Description: Potente strumento di ricerca (grep) integrato in Neovim, configurato per utilizzare
             `ripgrep` (rg) come backend principale. Permette di cercare testo in file, buffer,
             e repository git, presentando i risultati in modo flessibile.
Status: Active
Author: dnlhc (configurazione) / mhinz (plugin)
Repository: https://github.com/mhinz/vim-grepper
Notes:
 - Configurato per utilizzare `ripgrep` (rg) come backend predefinito per la sua velocità
   ed efficienza. Sono comunque disponibili `ag`, `pt`, e `git grep`.
 - Utilizza primariamente la **quickfix list** per visualizzare i risultati (`quickfix = 1`).
   Questa scelta è strategica per sfruttare appieno `nvim-bqf`.
 - **Integrazione con nvim-bqf**: La preferenza per la quickfix list permette di beneficiare
   delle funzionalità avanzate di `nvim-bqf`, tra cui:
    - **Anteprima integrata**: `nvim-bqf` fornisce una finestra di anteprima per le occorrenze
      selezionate nella quickfix list, aggiornata dinamicamente.
    - **Filtraggio con FZF**: Dalla quickfix list gestita da `nvim-bqf`, è possibile utilizzare
      `zf` (o il mapping configurato in `nvim-bqf`) per filtrare ulteriormente i risultati
      tramite FZF, migliorando drasticamente la navigazione di molte occorrenze.
 - Sono comunque presenti mappature dedicate per aprire Grepper in una finestra laterale
   (`-side`), offrendo flessibilità nel workflow.
 - Evidenziazione delle corrispondenze attiva nella lista dei risultati (`highlight = 1`).
 - Personalizzazione dei mapping nel prompt di Grepper per cambiare:
    - Tool di ricerca: `<Tab>`
    - Modalità di visualizzazione (quickfix/side): `<C-s>`
    - Directory di ricerca: `<C-d>`
 - Autocomando per `FileType GrepperSide`: Tenta di selezionare visivamente il termine
   cercato quando si usa la modalità `-side` (utile se non si usa nvim-bqf per questa vista).
 - Evidenziazioni personalizzate per `Directory` e `GrepperSideFile` per una migliore
   distinzione visiva.

Keymaps (Prefisso principale: <leader>s):
 - Gruppo " Grepper Quickfix" (risultati in quickfix, ideale con nvim-bqf):
    - <leader>ssG         → Cerca con `git` (quickfix)
    - <leader>ssg         → Cerca parola nel buffer corrente con `git` (quickfix) *
    - <leader>ssR         → Cerca con `rg` (quickfix, apre prompt)
    - <leader>ssr         → Cerca parola sotto cursore in tutti i file con `rg` (quickfix)
    - <leader>ssw         → Cerca parola nel buffer corrente con `rg` (quickfix)
    - <leader>ssW         → Cerca parola in tutti i buffer aperti con `rg` (quickfix)

 - Gruppo " Grepper Side" (risultati in pannello laterale):
    - <leader>sSG         → Cerca con `git` (side panel)
    - <leader>sSg         → Cerca parola nel buffer corrente con `git` (side panel) *
    - <leader>sSR         → Cerca con `rg` (side panel, apre prompt)
    - <leader>sSr         → Cerca parola sotto cursore in tutti i file con `rg` (side panel)
    - <leader>sSw         → Cerca parola nel buffer corrente con `rg` (side panel)
    - <leader>sSW         → Cerca parola in tutti i buffer aperti con `rg` (side panel)

 - Operatore Grepper:
    - gs (Normal/Visual)  → Avvia Grepper sull'operando di movimento o sulla selezione visuale

 - Mappings nella finestra dei risultati di Grepper (Quickfix/Side):
    - <CR>                → Apri risultato nel buffer corrente
    - <C-P>               → Apri risultato in finestra di anteprima (Preview Window)
    - v / s / t           → Apri risultato in vsplit / split / tab
    - q                   → Chiudi finestra Grepper/Quickfix

   (* Nota: i mapping `ssg` e `SSg` nella configurazione attuale eseguono una ricerca generica con git.
      Per "cerca parola nel buffer corrente con git", dovrebbero includere `-cword -buffer -noprompt`.)

TODO:
 - [ ] Verificare e allineare i comandi dei mapping `<leader>ssg` e `<leader>sSg` con le loro
       descrizioni, aggiungendo `-cword -buffer -noprompt` se l'intento è la ricerca specifica.
 - [ ] Esplorare ulteriori opzioni di `nvim-bqf` per personalizzare l'anteprima e l'integrazione
       con FZF, se necessario.
 - [ ] Valutare l'efficacia dell'autocomando per `GrepperSide` (selezione visuale) rispetto
       all'highlighting standard di Grepper, specialmente quando non si usa nvim-bqf.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["grepper"] = {
        "mhinz/vim-grepper",
        lazy = true,
        event = "VeryLazy",
        cmd = "Grepper",
    },
}

M.setup = {
    ["grepper"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["grepper"] = function()
        vim.g.grepper = {
            tools = {'rg', 'ag', 'pt', 'git'},
            highlight = 1,
            side = 0,
            quickfix = 1,
            prompt = 1,
            searchreg = 1,
            -- con Tab cambio modalita di ricerca
            prompt_mapping_tool = '<tab>',
            prompt_mapping_side = '<c-s>',
            prompt_mapping_dir = '<c-d>',
            rg = {
                grepprg = 'rg -H --color=never --no-heading --vimgrep --smart-case',
                -- grepformat = '%f:%l:%c:%m,%f',
                -- escape = '\\^$.*+?()[]{}|',
            },
        }
        -- Crea un gruppo di autocomandi
        local grepper_augroup = vim.api.nvim_create_augroup("GrepperGroup", { clear = true })

        -- Autocomando per GrepperSide
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "GrepperSide",
            group = grepper_augroup,
            command = [[silent execute 'keeppatterns v#'.b:grepper_side.'#>' | silent normal! ggn]]
        })
        -- Evidenziazioni
        vim.api.nvim_set_hl(0, 'Directory', {fg='#ffaf87', bg=nil})
        -- vim.api.nvim_set_hl(0, 'qfLineNr', {fg='#444444'})
        -- vim.api.nvim_set_hl(0, 'qfSeparator', {fg='#767676'})
        vim.api.nvim_set_hl(0, 'GrepperSideFile', {fg='#ffaf87'})

        vim.api.nvim_create_user_command(
            "Todo",
            function()
                vim.cmd('Grepper -noprompt -tool rg -grepprg "git grep -nIi \'\\(TODO\\|FIXME\\)\'"')
            end,
            { desc = "Search for TODO or FIXME tags using git grep with Grepper" }
        )
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>s"

    wk.add({
        -- Gruppo principale Grepper
        { prefix, group = " Grepper" },

        -- Sottogruppo Grepper Quickfix
        -- Con F6  la chiuso qunado finito
        { prefix .. "s", group = " Grepper Quickfix" },
        { prefix .. "sG", [[<Cmd>Grepper -tool git -quickfix<CR>]], desc = "Search with git" },
        { prefix .. "sg", [[<Cmd>Grepper -tool git -quickfix<CR>]], desc = "Search word in current buffer with git" },
        { prefix .. "sR", [[<Cmd>Grepper -tool rg -quickfix<CR>]], desc = "Search with rg" },
        { prefix .. "sr", [[<Cmd>Grepper -tool rg -quickfix -cword -noprompt<CR>]], desc = "Search word under cursor in all file" },
        { prefix .. "sw", [[<Cmd>Grepper -tool rg -quickfix -buffer -cword -noprompt<CR>]], desc = "Search word in current buffer" },
        { prefix .. "sW", [[<Cmd>Grepper -tool rg -quickfix -buffers -cword -noprompt<CR>]], desc = "Search word in current open buffer" },

        -- Sottogruppo Grepper Side
        { prefix .. "S", group = " Grepper Side" },
        { prefix .. "SG", [[<Cmd>Grepper -tool git -side<CR>]], desc = "Search with git" },
        { prefix .. "Sg", [[<Cmd>Grepper -tool git -side<CR>]], desc = "Search word in current buffer with git" },
        { prefix .. "SR", [[<Cmd>Grepper -tool rg -side<CR>]], desc = "Search with rg" },
        { prefix .. "Sr", [[<Cmd>Grepper -tool rg -side -cword -noprompt<CR>]], desc = "Search word under cursor in all file" },
        { prefix .. "Sw", [[<Cmd>Grepper -tool rg -side -buffer -cword -noprompt<CR>]], desc = "Search word in current buffer" },
        { prefix .. "SW", [[<Cmd>Grepper -tool rg -side -buffers -cword -noprompt<CR>]], desc = "Search word in current open buffer" },
    }, mapping.opt_mappping )

    -- Visual Mode: Seleziono testo gs e parte il grep sulla selezione
    -- Normal Mode: gs poi uso un movimento per aggiornare la ricerca
    vim.keymap.set({ 'n', 'x' }, 'gs', '<Plug>(GrepperOperator)', { remap = true })
end

return M

