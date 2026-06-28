# Convenzioni di stile, tooling e gotcha

## Lingua e commenti

- **Tutti i commenti sono in italiano.** Mantieni l'italiano quando modifichi o
  aggiungi codice. Non introdurre commenti in inglese in un file italiano.
- I commenti spiegano spesso il **perché** di una scelta (non solo il cosa):
  imita questo stile, soprattutto per scelte non ovvie o monkey-patch.

## Accenti → apostrofo negli header doc

Negli **header di documentazione** dei plugin (e in vari commenti) lo stile usa
l'**apostrofo al posto degli accenti**: `e'`, `gia'`, `piu'`, `pero'`. Rispetta
questa convenzione lì. (Nelle stringhe/notifiche utente runtime si trovano anche
accenti veri: segui il file che stai modificando.)

## Fold marker

Molti file usano marker di fold espliciti per organizzare le sezioni:

```lua
--{{{ Nome sezione
... codice ...
--}}} Nome sezione
```

La modeline in cima ad alcuni file li attiva:
`foldmarker=--{{{,--}}} foldmethod=marker`. Quando aggiungi codice a
`1-settings.lua` o `5-mapping.lua`, **mettilo nella sezione fold giusta**, non in
fondo a caso.

## Formattazione: stylua

Config in `.stylua.toml`. Indentazione **4 spazi** per i file Lua del progetto
(`expandtab`). Esegui `stylua` sui file modificati prima di chiudere.

> Attenzione: gli `ftplugin/*.lua` impostano lo `shiftwidth` *del filetype che
> editi* (es. `lua.lua` → 4, vedi cartella `ftplugin/`), non sono lo stile del
> codice del progetto. Per lo stile del codice vale `.stylua.toml`.

## Parse-check: `luac -p`

Dopo **ogni** modifica a un file `.lua`, verifica la sintassi:

```bash
luac -p lua/sphynx/plugins/<nome>.lua
```

`luac` si trova in `/ucrt64/bin` (toolchain MSYS/UCRT). Nessun output = OK.

## ⚠️ EOL / fine riga (gotcha importante su Windows)

Alcuni file possono avere **EOL misti / CR**. Il tool Edit normalizza a **LF**:
su un file con CR misti questo genera un diff enorme ("churn") di righe non
realmente modificate.

- Prima di editare misura i CR: `tr -cd '\r' < file | wc -c` (usa `tr`, **non**
  `grep`).
- Dopo un commit, verifica i CR con `git show` prima di un eventuale push.

## Path: Windows vs MSYS

- Nella **shell bash** (MSYS) i path sono in stile `/c/Users/<user>/AppData/...`.
- Negli **script Python/Ruby** o nei comandi Neovim usa path Windows
  `C:/Users/<user>/...`.
- Path utili a runtime sono già pronti in `sphynx.path` (vedi
  `architecture.md`): preferiscili a path hardcodati.

## Sorgenti dei plugin: sola lettura

I sorgenti installati da lazy stanno in
`…/AppData/Local/nvim-data/lazy/<plugin>`. Puoi **ispezionarli** per capire come
funziona un plugin, ma **non modificarli**: vengono sovrascritti a `:Lazy
update`. Ogni personalizzazione va nella config dell'utente
(`lua/sphynx/plugins/<plugin>.lua`), eventualmente come monkey-patch
nell'`M.configs` (segnalando che è fragile).

## lazy-lock.json

`lazy-lock.json` pinna le versioni dei plugin. Va **committato** dopo un
`:Lazy update`, così l'ambiente è riproducibile.

## Abbreviazioni utili (cmdline)

Definite in `1-settings.lua`: `LS`→`LspStart`, `LAS`→`Lazy show`,
`LAU`→`Lazy update`, `LAC`→`Lazy check`. `bp`→`binding.pry` (insert, per Ruby).

## Utility globali disponibili (`utils/init.lua`)

- `_G.P(v)` — print/inspect di un valore (debug).
- `_G.R(name)` — reload di un modulo Lua (lazy + plenary).
- `_G.reload_options()` — ricarica `1-settings.lua` (anche via autocomando al
  salvataggio di quel file).
- `utils.define_augroups{...}` — helper per creare gruppi di autocomandi
  (usato in `2-autocommands.lua`).
- `utils.plugin_is_installed(name)`, `utils.close_buffer`, `utils.closeAllBufs`,
  `utils.toggle_qf`, `utils.toggle_fold`, ecc.
