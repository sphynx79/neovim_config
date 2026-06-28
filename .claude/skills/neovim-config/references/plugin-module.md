# Convenzione di un modulo plugin (`lua/sphynx/plugins/<nome>.lua`)

Ogni plugin è **un file** che ritorna una tabella `M`. Il file NON chiama mai
`lazy.setup` né registra il plugin da solo: si limita a *dichiarare* le sue
parti, che `core/3-plugins.lua` raccoglie e trasforma in spec lazy (vedi
`architecture.md`).

## Le chiavi di `M`

| Chiave | Tipo | A cosa serve | Diventa, nella spec lazy |
|---|---|---|---|
| `M.plugins` | tabella keyed by nome | la **spec lazy** vera e propria (repo, lazy, trigger, dependencies) | la spec stessa |
| `M.setup` | tabella keyed by nome → funzione | codice da eseguire **prima** del load (di solito registra le keymap) | `init` |
| `M.configs` | tabella keyed by nome → funzione | codice di configurazione **al** load (di solito `require("plugin").setup{...}`) | `config` |
| `M.keybindings` | funzione | definisce le keymap (chiamata da `M.setup`) | — |

Solo `M.plugins` è obbligatoria. Aggiungi `setup`/`configs`/`keybindings` solo
se servono. La **chiave** dentro `M.plugins`/`M.setup`/`M.configs` (es.
`["telescope"]`) deve essere la stessa in tutte e tre, ed è il nome con cui il
modulo è elencato in `3-plugins.lua`.

## Header di documentazione (obbligatorio, in cima al file)

Tutti i file plugin iniziano con questo blocco. Mantieni l'allineamento e usa
**l'apostrofo al posto degli accenti** (`e'`, `gia'`, `piu'`), com'è nello stile
del progetto.

```text
--[[
===============================================================================================
Plugin: <nome-plugin>
===============================================================================================
Description: <descrizione su una o due righe, allineata sotto "Description: ">
Status: Active
Author: <autore>
Repository: <url>
Notes:
 - <nota rilevante sulla config reale: lazy loading, dipendenze, scelte fatte>
 - <...>
Keymaps:
 - <key>        → <cosa fa>
 - <:Comando>   → <cosa fa>
TODO:
 - [ ] <eventuale miglioramento futuro>     (sezione opzionale)
===============================================================================================
--]]
```

Esempi reali da imitare: `telescope.lua` (config corposa + più funzioni),
`gitsigns.lua` (config + keymap minimali), `hop.lua` (solo keymap).

## Scheletro minimo (solo dichiarazione)

```lua
local M = {}

M.plugins = {
    ["nomeplugin"] = {
        "autore/nomeplugin.nvim",
        lazy = true,
        -- UN trigger di lazy loading (vedi sotto):
        event = { "BufReadPost", "BufNewFile" },
        -- cmd = { "Comando" },
        -- keys = { "<leader>x" },
        -- dependencies = { "nvim-lua/plenary.nvim" },
    },
}

return M
```

## Scheletro completo (config + keymap)

Pattern usato da quasi tutti i plugin interattivi:

```lua
local M = {}

M.plugins = {
    ["nomeplugin"] = {
        "autore/nomeplugin.nvim",
        lazy = true,
        cmd = "NomePluginToggle",
    },
}

-- gira PRIMA del load: tipicamente registra le keymap (che poi caricheranno
-- il plugin al primo uso)
M.setup = {
    ["nomeplugin"] = function()
        M.keybindings()
    end,
}

-- gira AL load del plugin: la configurazione vera
M.configs = {
    ["nomeplugin"] = function()
        require("nomeplugin").setup({
            -- opzioni del plugin, con commenti in italiano
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")

    wk.add({
        { "<leader>x", group = " NomePlugin" },
    })

    mapping.register({
        {
            mode = { "n" },
            lhs = "<leader>xx",
            rhs = [[<Cmd>NomePluginToggle<CR>]],
            options = { silent = true },
            description = "Toggle nomeplugin",
        },
    })
end

return M
```

## Trigger di lazy loading

Tutto è `lazy = true` di default. Scegli **come** si carica il plugin:

- `event = { "BufReadPost", "BufNewFile" }` — all'apertura di un file (la scelta
  più comune per plugin "passivi": gitsigns, treesitter, ecc.).
- `cmd = { "Telescope", "..." }` — al primo uso di un comando.
- `keys = { "<leader>x" }` — alla pressione di una keymap.
- Nessun trigger esplicito + keymap che fa `require("plugin")` → il `require`
  dalla keymap carica il plugin al primo uso (pattern di `hop.lua`).

## Registrare il plugin in `3-plugins.lua`

Dopo aver creato il file, aggiungi il **nome** (la stringa, senza estensione)
alla tabella `modules` di `core/3-plugins.lua`, nella categoria giusta
(`--{{{ UI`, `--{{{ LSP`, `--{{{ GIT`, `--{{{ MISC`, …) e con un commento
allineato in stile:

```lua
    "nomeplugin",               -- OK - Cosa fa in breve
```

Per **disabilitare** un plugin senza cancellarlo: spostane/commentane la riga
nella sezione "PLUGIN DISABILITATI" in fondo (es. `-- "nomeplugin",`).

## Dipendenze

Si dichiarano dentro la spec, come in `telescope.lua`:

```lua
dependencies = {
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
},
```

## Dopo ogni modifica

- Parse-check: `luac -p lua/sphynx/plugins/<nome>.lua` (`luac` è in `/ucrt64/bin`
  sotto MSYS).
- Formattazione: `stylua` (config in `.stylua.toml`).
- Vedi `conventions.md` per EOL e altri gotcha.
