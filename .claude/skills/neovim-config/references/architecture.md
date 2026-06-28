# Architettura e ordine di caricamento

## Namespace globale `sphynx`

`init.lua` crea `_G.sphynx = {}` come **unico namespace globale** del progetto.
Da lì pendono:

- `sphynx.path` — path utili calcolati una volta:
  - `nvim_config` = `stdpath("config")` (la cartella di config)
  - `plugin_folder` = `stdpath("data") .. "/lazy"` (dove lazy installa i plugin)
  - `plugin_lazy_folder` = `…/lazy/lazy.nvim`
  - `plugin_config_folder` = `…/lua/sphynx/plugins/`
- `sphynx.config` — gli switch di alto livello (vedi sotto), popolata da
  `core/0-config.lua`.
- `sphynx.modules` — tabella riempita a runtime con i moduli plugin caricati.

`init.lua` inoltre imposta **i leader prima di tutto** (obbligatorio: devono
precedere il caricamento di plugin/keymap):

```lua
vim.g.mapleader = " "       -- <Space>
vim.g.maplocalleader = ","  -- <localleader> = virgola
vim.loader.enable()         -- bytecode cache nativa
```

Poi fa solo `require("sphynx.core")`.

## Ordine di caricamento (`lua/sphynx/core/init.lua`)

Sincrono allo startup, in quest'ordine:

1. `core.0-config` → `.load()` popola `sphynx.config`
2. `core.1-settings` → opzioni `vim.opt` / `vim.g`
3. `core.2-autocommands` → autocomandi globali
4. `core.3-plugins` → costruisce la spec e chiama `lazy.setup(...)`

Poi, **all'evento `User VeryLazy`** (cioè dopo che lazy ha finito l'avvio), in
modo differito:

5. `core.4-commands` → comandi `:Comando`
6. `core.5-mapping` → keymap globali
7. `sphynx.ui` → UI custom
8. `sphynx.utils.view`.setup()

Implicazione pratica: se aggiungi qualcosa che deve esistere **prima** dei
plugin (es. un'opzione che un plugin legge all'init), va in `1-settings`. Se può
aspettare l'UI pronta, può stare nel blocco `VeryLazy`.

## Come `3-plugins.lua` trasforma i moduli in spec lazy

`core/3-plugins.lua` è il cuore del sistema. Funziona così:

1. C'è una lista `modules` = nomi di file (stringhe) raggruppati per categoria
   con marker di fold `--{{{ CATEGORIA … --}}}`. I plugin **disabilitati** sono
   righe commentate nella sezione "PLUGIN DISABILITATI" in fondo: per
   riattivarne uno si **scommenta** la riga (non si cancella il file).
2. `theme()` decide se caricare il modulo `nightfox` o `onenord` in base a
   `sphynx.config.colorscheme`.
3. `set_modules_config()` fa `require("sphynx.plugins."..nome)` per ogni nome e
   salva il risultato in `sphynx.modules[nome]`. Se un require fallisce, mostra
   un `vim.notify` di warning ma **non** blocca il resto.
4. `read_plugin_config()` scorre tutti i moduli e, per ogni voce in
   `mod.plugins`:
   - se esiste `mod.setup[plugin]` (funzione), la aggancia come **`init`** della
     spec lazy (gira prima che il plugin venga caricato);
   - se esiste `mod.configs[plugin]` (funzione), la aggancia come **`config`**
     (gira al caricamento del plugin);
   - accumula tutto in una lista piatta di spec.
5. Quella lista viene passata a `lazy.setup(specs, opts)`.

### Opzioni rilevanti passate a `lazy.setup`

- `defaults = { lazy = true }` → **tutto è lazy di default**; ogni plugin deve
  dichiarare il proprio trigger (`cmd`, `keys`, `event`, oppure require da una
  keymap).
- `lockfile` = `…/nvim/lazy-lock.json` (versioni pinnate; committalo dopo gli
  update).
- `install.colorscheme = { "nordfox" }`, `concurrency = 20`.
- `rocks.enabled = true`, `pkg.enabled = true` (luarocks/rockspec supportati).
- `performance.rtp.reset = true` + lunga lista di `disabled_plugins` nativi.
- `change_detection.enabled = false` (niente reload automatico al salvataggio
  della config: le modifiche si applicano riavviando o ricaricando a mano).

## `sphynx.config` — gli switch di alto livello (`0-config.lua`)

Tabella centrale dei comportamenti. Campi principali:

- `auto_save_buffer` (bool) — salvataggio automatico su `FocusLost`
  (autocomando in `2-autocommands.lua`).
- `cursorline` (bool) — abilita gli autocomandi che accendono/spengono
  `cursorline` per finestra.
- `colorscheme` (string) — uno tra `nightfox/dayfox/dawnfox/duskfox/nordfox/
  terafox/carbonfox/onenord`. **Questo** decide quale modulo tema viene
  caricato.
- `transparent_background` (bool).
- `autocomplete` (string) — `"blink"` (attivo) oppure `"cmp"`. Cambiando questo,
  ricordati di allineare i moduli attivi in `3-plugins.lua`.
- `ui.tabufline` — `{ enabled, lazyload, order, bufwidth }` per la tab/buffer
  line custom in `lua/sphynx/ui/tabufline/`.
- `excluded_filetypes` — lista di filetype "speciali" (help, NvimTree,
  Trouble, qf, TelescopePrompt, noice, …) che vari plugin/UI ignorano.
- `border_style` — caratteri+highlight dei bordi delle finestre flottanti.
- `nvim_lint_dir`, `code_snippets_directory` — path derivati.

Quando l'utente dice "cambia tema", "attiva la trasparenza", "passa a cmp",
"disattiva l'autosave" → quasi sempre si tocca **qui**.

## File ai bordi del sistema

- `ftdetect/filetype.lua` — detection di filetype custom.
- `after/plugin/options.lua` — opzioni applicate **dopo** i plugin.
- `compiler/`, `lint/` — compiler e config linter.
- `ginit.vim`, `mswin.vim` — supporto GUI / Windows (caricato in `1-settings`
  se siamo su Windows).
- `snippets/` — snippet in **formato VSCode** (`package.json` +
  `snippets/*.json`), organizzati per linguaggio.
