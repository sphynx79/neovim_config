# Inventario plugin

Fonte di verità: la tabella `modules` in `lua/sphynx/core/3-plugins.lua`. Questo
elenco è una mappa ragionata; in caso di dubbio rileggi quel file (e
`lazy-lock.json` per le versioni pinnate).

- **Plugin manager**: lazy.nvim. **Completion**: `blink` (switch
  `sphynx.config.autocomplete`, alternativa `cmp`). **Tema**: nightfox/onenord
  via `sphynx.config.colorscheme`.

## Attivi, per categoria

### UI
- `ufo` — folding migliorato
- `illuminate` — evidenzia le altre occorrenze della parola sotto il cursore
- `vim-mark` — evidenzia parole/pattern con colori persistenti
- `foldsigns` — segni nelle sezioni piegate
- `heirline` — statusline + winbar
- `indent-blankline` — linee di indentazione
- `devicons` — icone file
- `smoothcursor` — animazione cursore nella colonna sinistra
- `colorful-winsep` — bordo colorato della finestra attiva
- `bqf` — quickfix migliorata
- `rainbow-delimiters` — parentesi colorate

### Mapping
- `which-key` — popup con le combinazioni disponibili

### LSP
- `lspconfig` — configurazione LSP
- `lazydev` — sviluppo Lua per Neovim
- `floating-tag-preview` — tag in finestra flottante
- `lsp-smag` — sostituisce i tag (ctags) con sistema smart via LSP
- `dd` — defer dei diagnostici
- `goto-preview` — anteprime flottanti dei risultati LSP
- `glance` — finestra preview stile VSCode (definizioni/riferimenti/…)

### Completion
- `blink` — autocompletamento asincrono (attivo)
- `autopair` — coppie di caratteri automatiche

### Debug
- `dap` — debug
- `dap-virtual-text` — valori variabili inline
- `dap-telescope` — integrazione dap+telescope

### Language
- `ruby-interpolation` — interpolazione stringhe Ruby
- `render-markdown` — rendering Markdown nel buffer

### File browser & navigation
- `nvim-tree` — file explorer (sidebar)
- `telescope` — fuzzy finder estendibile
- `cybu` — switch buffer con Tab
- `nvim-window-picker` — salto rapido tra finestre
- `maximizer` — massimizza/ripristina finestra
- `workspace` — tab come workspace stile i3 (buffer isolati per tab)
- `matchup` — estende `%` a costrutti del linguaggio
- `hop` — motion stile EasyMotion
- `marks` — potenzia i mark nativi

### Search
- `hlslens` — indice/totale delle corrispondenze di ricerca
- `grepper` — ricerca testo (rg/git) → quickfix/side, integrata con bqf

### Git
- `gitsigns` — segni git nel gutter, navigazione/preview/blame hunk
- `diffview` — vista diff a schermo intero, file history

### Editing
- `comment` — commenta/decommenta
- `treehopper` — selezione nodi treesitter via hop (`~`)

### Misc
- `treesitter` — parsing/evidenziazione
- `treesitter-textobjects` — text object via treesitter (metodi/classi)
- `noice` — UI di messaggi/cmdline/popupmenu
- `color` — color picker (Oklch) + highlight colori
- `neoformat` — formattatore multi-linguaggio (`<F8>`)
- `neoterm` — terminale integrato (debug Ruby con PRY)
- `neoscroll` — smooth scroll
- `neoclip` — clipboard manager (yank ring via Telescope, `<leader>ty`)
- `surround` — surround di coppie
- `todo-comments` — evidenzia/cerca TODO/FIX/HACK (`<leader>x`)
- `trouble` — lista diagnostics/riferimenti/symbols/quickfix (`<leader>k`)
- `aerial` — outline del codice
- `nvim-pasta` — yank/paste con cronologia (rimappa `p`/`P`)
- `sayonara` — chiusura intelligente buffer/finestra
- `virtcolumn` — colonna verticale per righe troppo lunghe
- `tabby` — line buffer e tab

## Disabilitati (commentati in `3-plugins.lua` — scommenta per riattivare)

`satellite`, `scrollview` (UI) · `lspsaga`, `lsp_signature` (LSP) · `luasnip`,
`cmp`, `cmp-cmdline` (completion alternativa) ·
`one-small-step-for-vimkind` (debug Lua) · `nim`, `markdown-preview`,
`markdown` (vim-markdown, in conflitto di conceal con render-markdown) ·
`window`, `windowswap`, `scope`, `clap` (navigation) · `spaceless` (editing) ·
`faster`, `focus`, `tabular`, `vimade`, `symbols-outline`, `vista` (misc).

> Nota: esistono in `lua/sphynx/plugins/` anche file non in lista (es.
> `XXXXXXXXXXXX.lua`, `core.lua`, palette tema): non sono "plugin disabilitati",
> sono moduli di servizio o segnaposto. La lista autorevole resta `modules` in
> `3-plugins.lua`.
