
--[[
===============================================================================================
Plugin: markdown-preview.nvim
===============================================================================================
Description: Fornisce un'anteprima live nel browser per i file Markdown.
Status: Active
Author: iamcco
Repository: https://github.com/iamcco/markdown-preview.nvim
Notes:
 - Richiede un passaggio di `build` per installare le dipendenze (server Node.js).
 - Configurato per il caricamento lazy tramite comandi (`MarkdownPreviewToggle`, `MarkdownPreview`,
   `MarkdownPreviewStop`) o all'apertura di file Markdown (`ft = markdown`).
 - Attivato esplicitamente solo per il filetype `markdown` (`g:mkdp_filetypes`).
 - Impostato per un refresh rapido dell'anteprima (`g:mkdp_refresh_slow = 0`).
 - La sezione `M.configs` ridefinisce i comandi base come buffer-local, il che è
   probabilmente ridondante dato che il plugin fornisce già comandi globali.
Keymaps:
 - Nessuna keymap specifica definita in questa configurazione.
 - Comandi disponibili: `MarkdownPreview`, `MarkdownPreviewStop`, `MarkdownPreviewToggle`.
TODO:
 - [ ] Considerare l'aggiunta di keymap personalizzate per un accesso più rapido (es. `<leader>mp`).
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["markdown_preview"] = {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        lazy = true,
    },
}

M.setup = {
    ["markdown_preview"] = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_refresh_slow = 0
    end
}

M.configs = {
    ["markdown_preview"] = function()
        vim.cmd([[
            command! -buffer MarkdownPreview call mkdp#util#open_preview_page()
            command! -buffer MarkdownPreviewStop call mkdp#util#stop_preview()
            command! -buffer MarkdownPreviewToggle call mkdp#util#toggle_preview()
        ]])
    end,
}

return M

