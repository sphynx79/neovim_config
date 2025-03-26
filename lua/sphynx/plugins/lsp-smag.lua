
--[[
===============================================================================================
Plugin: nvim-lsp-smag
===============================================================================================
Description: Sostituisce l'uso dei tag file (ctags) con un sistema smart basato su LSP,
             integrando in un'unica query definizione, dichiarazione, implementazione e tipo.
Status: Active
Author: Thore Weilbier
Repository: https://github.com/weilbith/nvim-lsp-smag
Notes:
 - Usa il supporto LSP per risolvere i tag dinamicamente
 - Intercetta automaticamente i comandi `:tag`, `:tjump`, `:tselect`, `:tnext`, etc.
 - Supporta fallback automatico ai tag file classici se l’LSP non è attivo o non risponde
 - Richiede un nome di tag (es. `<cword>`) anche se l’LSP lavora da posizione corrente
 - Altamente configurabile con:
     - `g:lsp_smag_enabled_providers` → LSP features da interrogare (default: tutti)
     - `g:lsp_smag_tag_kind_priority_order` → Ordine di priorità dei risultati
     - `g:lsp_smag_fallback_tags` → Se attivare il fallback a ctags
 - Integrazione seamless, zero config necessaria per l'uso base
 - Caricato in modalità lazy con evento `VeryLazy` (perfetto per startup rapido)
Keymaps:
 - t<Left>   → Torna indietro nello stack dei tag (equivalente a `<C-T>`)
 - t<Right>  → Salta alla definizione del simbolo sotto il cursore (`:tjump`)
 - tv        → Salta alla definizione in `vsplit`
 - ts        → Salta alla definizione in `split`
 - tS        → Mostra lo stack dei tag (`:tags`)
 - t         → Gruppo " Tags" in `which-key` per miglior UX
TODO:
 - [ ] Vedere se abilitare lsp_smag_fallback_tags
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["lsp_smag"] = {
        "weilbith/nvim-lsp-smag",
        lazy = true,
        event = "LspAttach",
    },
}

return M
