# Keymap: schema, helper e tasti "sacrificati"

## Leader

- `<leader>` = **`<Space>`**
- `<localleader>` = **`,`** (virgola)

Impostati in `init.lua` prima di tutto.

## I due modi di definire keymap

### 1. `mapping.register` (helper del progetto)

Definito in `core/5-mapping.lua`. Prende una lista di tabelle con campi
espliciti; il campo `description` viene copiato in `options.desc`
automaticamente.

```lua
local mapping = require("sphynx.core.5-mapping")
mapping.register({
    {
        mode = { "n" },                       -- o { "n", "v" }, { "i" }, ...
        lhs = "<leader>xx",
        rhs = [[<Cmd>Comando<CR>]],            -- stringa o function
        options = { silent = true },
        description = "Cosa fa",               -- mostrato anche da which-key
    },
})
```

### 2. `which-key` (`wk.add`)

Per **gruppi** (il sottomenu che compare premendo un prefisso) e per voci
rapide. Si passa spesso un preset di opzioni come secondo argomento.

```lua
local wk = require("which-key")
wk.add({
    { "<leader>x", group = " NomeGruppo" },
    { "<leader>xx", [[<Cmd>Comando<CR>]], desc = "Cosa fa" },
}, mapping.opt_mappping)
```

Regola pratica: usa `wk.add` per dichiarare i **gruppi** (l'icona + nome che
appare nel popup) e per le voci legate a un prefisso; usa `mapping.register` per
le keymap "piatte" con `mode/rhs/options` espliciti. Molti file usano entrambi.

## Preset di opzioni (in `core/5-mapping.lua`)

Tabelle pronte da passare a `wk.add`/come base:

| Preset | mode | prefix | note |
|---|---|---|---|
| `mapping.opt_mappping` | `n` | — | normale, silent+noremap+nowait |
| `mapping.opt_visual` | `v` | — | visual |
| `mapping.opt_plugin` | `n` | `<leader>` | normale con leader |
| `mapping.opt_plugin_visual` | `v` | `<leader>` | visual con leader |
| `mapping.opt_mappping_localleader` | `n` | `<localleader>` | con localleader |

Tutti hanno `silent/noremap/nowait = true` e `buffer = nil` (globali).

## Dove vanno le keymap

- **Globali** (movimenti, finestre, buffer, editing, configurazione nvim) →
  `core/5-mapping.lua`, raggruppate per sezione con fold marker `--{{{ … --}}}`
  (Folding, Moving around, Window, Buffer, Editing, Search & Replace, Ctags,
  QuickFix, Neovim Configuration, …).
- **Di un plugin** → dentro `M.keybindings` nel file del plugin, richiamata da
  `M.setup` (vedi `plugin-module.md`).

## Schema dei prefissi (gruppi which-key)

Prefissi già occupati — riusali in modo coerente:

| Prefisso | Tema |
|---|---|
| `<leader>t` | Telescope (find/grep/lsp/neoclip/…) |
| `<leader>n` | Neovim (apri file di config: init, core, mapping, plugins) |
| `<leader>g` | Git (gitsigns) |
| `<leader>w` | Workspace (tab stile i3) |
| `<leader>k` | Trouble |
| `<leader>x` | todo-comments (jump) |
| `b` | Buffers |
| `w` | Window (focus/resize/new/move) |
| `z` | Folding |
| `t` (senza leader) | Tags (ctags) |
| `h` | **Hop** (vedi sotto) |

## ⚠️ Tasti nativi "sacrificati" (rimappati di proposito)

Prima di rimappare un tasto, controlla che non sia uno di questi — alcuni
movimenti nativi sono stati **volutamente sostituiti**:

- `h` → **Hop** (NON è più "vai a sinistra"; ci si muove con hop). Per far
  comparire il popup which-key su `h` serve la voce `{ "h", mode = "n" }` nei
  triggers di `which-key.lua`.
- `f` / `F` → **Hop** inizio/fine parola sulla linea (NON più find-char nativo).
- `9` → `$` (fine riga) · `0` → `^` (inizio riga non-blank) · `8` → centro riga.
- `'` → `` ` `` (vai alla posizione esatta del mark).
- `<C-s>` → salvataggio silenzioso (`update`) in n/v/i.
- `<C-a>` → seleziona tutto il buffer.
- `~` → treehopper (selezione nodi treesitter via hop).

Se l'utente chiede di rimappare uno di questi, fai notare il conflitto prima di
procedere.

## Convenzioni di stile keymap

- `rhs` come stringa usa `[[<Cmd>...<CR>]]` (doppie parentesi quadre), spesso
  `[[<Cmd>lua require('plugin').funzione()<CR>]]`.
- Naviga i sottomenu spesso con le **frecce** (`<Up>/<Down>/<Left>/<Right>`)
  invece di lettere (es. resize finestre `wr<Up>`, hunk git `<leader>g<Down>`).
- I gruppi which-key hanno un'icona Nerd Font nel nome (es. `" Buffers"`,
  `"󰋟 Hop"`).
