--[[
===============================================================================================
Plugin: vim-markdown
===============================================================================================
Description: Fornisce syntax highlighting avanzato, corrispondenza di elementi, folding
             e altre utilità per la modifica di file Markdown in Vim/Neovim.
Status: Active
Author: plasticboy (e contributors)
Repository: https://github.com/plasticboy/vim-markdown
Notes:
 - Configurato per utilizzare il branch 'master'.
 - Ha una dipendenza dichiarata: 'godlygeek/tabular' (probabilmente per la formattazione delle tabelle).
 - Caricato pigramente (lazy-loaded) solo all'apertura di file Markdown (ft = "markdown").
   - `lazy = true` è specificato, anche se implicito con `ft`.
 - Configurazione specifica applicata tramite la funzione M.setup["markdown"]:
   - Abilitato il supporto per la sintassi matematica (MathJax) (`vim_markdown_math = 1`).
   - Abilitato il riconoscimento del frontmatter YAML/TOML (`vim_markdown_frontmatter = 1`).
   - Abilitata la funzione 'conceal' per nascondere i caratteri di markup (`vim_markdown_conceal = 1`).
   - Livello di 'conceal' impostato a 2 (`vim_markdown_conceal_level = 2`), nasconde i delimitatori
     di markup (es. *, _) e gli URL dei link, mostrando solo il testo del link.
Keymaps:
 - Nessuna mappatura specifica definita in questa configurazione.
   (La formattazione delle tabelle con Tabular richiede comandi specifici, es. :Tabularize /|)
TODO:
 - [ ] Vedere se ci sono alternative piu moderne
 - [ ] Definire eventuali keymap personalizzate per azioni frequenti (es. formattazione tabelle).
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["markdown"] = {
        "plasticboy/vim-markdown",
        branch = 'master',
        dependencies = "godlygeek/tabular",
        ft = "markdown",
        lazy = true,
    },
}


M.setup = {
    ["markdown"] = function()
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_frontmatter = 1
        vim.g.vim_markdown_conceal = 1
        vim.g.vim_markdown_conceal_level = 2
        vim.g.vim_markdown_folding_style_pythonic = 1
    end
}

return M
