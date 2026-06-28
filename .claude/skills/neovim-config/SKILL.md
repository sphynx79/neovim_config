---
name: neovim-config
description: >-
  Architettura, convenzioni e mappa della configurazione Neovim personale di
  Sphynx (namespace `sphynx`, plugin manager lazy.nvim, commenti in italiano).
  USA SEMPRE questa skill quando lavori dentro la cartella di config Neovim
  (`C:/Users/<user>/AppData/Local/nvim`, `init.lua`, `lua/sphynx/**`,
  `ftplugin/`, `after/`) o quando l'utente chiede di aggiungere/modificare un
  plugin, una keymap, un settaggio (`vim.opt`), un autocomando, un comando, una
  config per linguaggio o uno snippet in Neovim. Vale anche se l'utente non
  nomina esplicitamente i file: parole come "il mio nvim", "la mia config vim",
  "aggiungi il plugin X", "rimappa il tasto Y", "cambia colorscheme" devono far
  scattare questa skill, così segui le convenzioni del progetto invece di
  inventare una struttura nuova.
---

# Configurazione Neovim di Sphynx

Questa è una configurazione Neovim **custom** (non LazyVim/NvChad/AstroNvim,
anche se prende in prestito l'idea della tabufline da NvChad). Tutto vive sotto
il namespace globale `_G.sphynx` ed è scritto in Lua con **commenti in
italiano**. Prima di toccare qualunque cosa, segui le convenzioni qui sotto: lo
scopo di questa skill è farti modificare la config *come la modificherebbe il
proprietario*, non reinventare la struttura.

## La regola d'oro

Ogni cosa ha un posto preciso e un pattern preciso. Se devi aggiungere un
plugin, una keymap o un settaggio, **copia lo stile di un vicino esistente**.
Quando hai un dubbio su dove va una cosa, cercala con un file simile già
presente e imita quel file.

## Mappa rapida — dove vive cosa

| Vuoi toccare… | File |
|---|---|
| Entry point, leader, path globali | `init.lua` |
| Switch globali (colorscheme, autocomplete, tabufline, filetype esclusi) | `lua/sphynx/core/0-config.lua` |
| Opzioni Neovim (`vim.opt`, `vim.g`) | `lua/sphynx/core/1-settings.lua` |
| Autocomandi globali | `lua/sphynx/core/2-autocommands.lua` |
| Elenco plugin attivi/disattivati (lazy loading) | `lua/sphynx/core/3-plugins.lua` |
| Comandi utente (`:Comando`) | `lua/sphynx/core/4-commands.lua` |
| Keymap globali (non legate a un plugin) | `lua/sphynx/core/5-mapping.lua` |
| Config di UN plugin | `lua/sphynx/plugins/<nome>.lua` |
| Settaggi per linguaggio | `ftplugin/<filetype>.lua` |
| Funzioni di utilità condivise | `lua/sphynx/utils/init.lua` |
| Colori/palette tema | `lua/sphynx/colors/` |
| UI custom (statusline heirline, tabufline) | `lua/sphynx/ui/` |
| Snippet (formato VSCode) | `snippets/snippets/` |

I dettagli completi sono nei file di riferimento — leggili **prima** di agire sul
tema corrispondente:

- `references/architecture.md` — ordine di caricamento, namespace, come lazy.nvim
  legge i moduli. Leggilo se devi capire *quando/come* gira qualcosa.
- `references/plugin-module.md` — la convenzione esatta di un file
  `plugins/<nome>.lua` (con template). Leggilo **sempre** prima di
  aggiungere/modificare un plugin.
- `references/keymaps.md` — schema dei leader, preset, tasti "sacrificati",
  `mapping.register` vs `which-key`. Leggilo prima di toccare keymap.
- `references/plugins-inventory.md` — elenco ragionato dei plugin attivi e
  disabilitati, per categoria.
- `references/conventions.md` — stile codice, commenti, accenti, EOL, tooling
  (`stylua`, `luac -p`), gotcha Windows/MSYS.

## I tre task più comuni (riassunto)

I passi qui sotto bastano per i casi semplici; per i dettagli vai al reference
indicato.

### 1. Aggiungere un plugin

1. Crea `lua/sphynx/plugins/<nome>.lua` che ritorna una tabella `M` con
   `M.plugins`, e — se servono — `M.setup`, `M.configs`, `M.keybindings`.
   Copia un file esistente vicino per tipologia (es. `hop.lua` se ha keymap,
   `gitsigns.lua` se ha config). Metti in cima l'**header di documentazione**
   (template in `references/plugin-module.md`).
2. Registra il nome del plugin nella tabella `modules` di
   `lua/sphynx/core/3-plugins.lua`, **nella categoria giusta** (`--{{{ ... --}}}`),
   con un commento `-- OK - <cosa fa>` allineato come gli altri.
3. `luac -p lua/sphynx/plugins/<nome>.lua` per il parse-check.

Dettagli e template completo: `references/plugin-module.md`.

### 2. Aggiungere una keymap

- **Globale** (non legata a un plugin): va in `lua/sphynx/core/5-mapping.lua`,
  con `mapping.register({...})` (campi `mode/lhs/rhs/options/description`) oppure
  `require("which-key").add({...})` per i gruppi.
- **Di un plugin**: va dentro `M.keybindings` nel file del plugin, richiamata da
  `M.setup`.

Rispetta lo **schema dei prefissi** (leader `<Space>`, localleader `,`) e
attenzione ai **tasti già rimappati** (es. `h` = hop, `f`/`F` = hop, `9`/`0` =
`$`/`^`). Vedi `references/keymaps.md`.

### 3. Aggiungere/cambiare un settaggio

- Opzione Neovim generale → `lua/sphynx/core/1-settings.lua`, dentro la sezione
  fold corretta (`--{{{ UI Setting --}}}`, `--{{{ Folding --}}}`, ecc.).
- Switch di alto livello (es. `colorscheme`, `autocomplete = "blink"`,
  `transparent_background`) → `lua/sphynx/core/0-config.lua` (`sphynx.config`).
- Settaggio per un solo linguaggio (es. `shiftwidth` per Python) →
  `ftplugin/<filetype>.lua`.

## Cosa NON fare

- **Non** introdurre un framework o un `lazy.setup` con la spec inline classica:
  qui i plugin si dichiarano come moduli `M.plugins` letti da `3-plugins.lua`.
- **Non** modificare i sorgenti dei plugin in
  `…/AppData/Local/nvim-data/lazy/<plugin>` (vengono sovrascritti da
  `:Lazy update`). Le modifiche vanno solo nella config dell'utente.
- **Non** scrivere commenti in inglese se intorno sono in italiano, e **non**
  usare accenti dove lo stile del file usa l'apostrofo (`e'`, `gia'`, `piu'`) —
  vedi `references/conventions.md`.
- **Non** dimenticare il parse-check `luac -p` dopo ogni modifica `.lua` e
  l'attenzione agli **EOL** (il tool Edit normalizza a LF: occhio ai file con
  CR misti).
