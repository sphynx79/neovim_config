--[[
===============================================================================================
Plugin: render-markdown.nvim
===============================================================================================
Description: Abbellisce la vista dei file Markdown direttamente dentro Neovim (heading con
             icone, code block, checkbox, callout, tabelle, link) senza finestre esterne.
             In insert/visual mostra il markup raw, in normal lo rende.
Status: Active
Author: MeanderingProgrammer
Repository: https://github.com/MeanderingProgrammer/render-markdown.nvim
Notes:
 - Requisiti soddisfatti: nvim 0.12.2 (richiesto >= 0.9), parser treesitter markdown e
   markdown_inline BUNDLED in nvim (C:/Appl/Neovim/lib/nvim/parser/), non in nvim-data.
   Parser opzionali gia' presenti: html (conceal commenti HTML), latex (formule), yaml
   (frontmatter). Icon provider: nvim-web-devicons (per le icone dei code block).
 - Caricamento lazy su ft = "markdown": il plugin si attiva solo sui file markdown.
 - dependencies dichiarate coi nomi-repo gia' usati nel progetto (treesitter e
   kyazdani42/nvim-web-devicons) per non creare spec duplicati e garantire l'ordine di load.
 - completions.lsp.enabled = true: registra un LSP in-process; blink.cmp completa
   automaticamente callout ([!NOTE]...), checkbox e destinazioni dei link nei file markdown.
 - conceallevel: il plugin lo gestisce da se' per-finestra (lo alza a 3 quando rende, lo
   ripristina uscendo), quindi il default globale conceallevel=0 NON va toccato.
 - vim-markdown (plugins/markdown.lua) e' tenuto DISABILITATO (sezione DISABLED LANGUAGE in
   3-plugins.lua): faceva conceal sugli stessi delimitatori e si sovrapporrebbe al rendering.
 - markdown-preview.nvim resta attivo e complementare: rende nel browser, non nel buffer.
Keymaps:
 - (nessuna keymap) il prefix <leader>m e' gia' interamente di marks.nvim; si usano i comandi
Commands:
 - :RenderMarkdown toggle      → attiva/disattiva il rendering (globale)
 - :RenderMarkdown enable      → attiva il rendering
 - :RenderMarkdown disable     → disattiva il rendering
 - :RenderMarkdown buf_toggle  → attiva/disattiva solo per il buffer corrente
 - :RenderMarkdown preview     → mostra il buffer renderizzato di fianco
TODO:
 - [ ] Valutare il preset = "obsidian" (mimica la UI di Obsidian) per i .md del vault Sinapsi
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["render-markdown"] = {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter", "kyazdani42/nvim-web-devicons" },
        lazy = true,
    },
}

M.configs = {
    ["render-markdown"] = function()
        require("render-markdown").setup({
            completions = {
                lsp = { enabled = true }, -- blink.cmp completa callout/checkbox/link nei .md
            },
        })
    end,
}

return M
