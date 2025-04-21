--[[
===============================================================================================
Plugin: nvim-autopairs
===============================================================================================
Description: Plugin per l'inserimento automatico e la gestione di coppie di caratteri
             (parentesi, virgolette, ecc.), con supporto per regole personalizzate
             e integrazione con Treesitter e sistemi di completamento.
Status: Active
Author: windwp
Repository: https://github.com/windwp/nvim-autopairs
Notes:
 - Integrazione con Treesitter abilitata (`check_ts = true`) per un pairing più
   consapevole del contesto.
 - Disabilitato per i tipi di file specificati nella tabella condivisa
   `sphynx.config.excluded_filetypes`.
 - Configurazione Treesitter specifica:
    - Lua: Pairing disabilitato all'interno di nodi 'string'.
    - Javascript: Pairing disabilitato all'interno di nodi 'template_string'.
    - Java: Controllo Treesitter completamente disabilitato.
 - Regole personalizzate specifiche per Lua (basate su Treesitter):
    - `%` viene accoppiato solo se il cursore si trova dentro un nodo 'string' o 'comment'.
    - `$` viene accoppiato solo se il cursore NON si trova dentro un nodo 'function'.
 - Integrazione con `nvim-cmp`:
    - Aggiunge automaticamente `(` dopo la conferma di *qualsiasi* elemento di
      completamento nella maggior parte dei filetype (`all = "("`).
    - Aggiunge automaticamente `{` dopo la conferma di *qualsiasi* elemento di
      completamento nei file `tex` (`tex = "{"`).
 - Utilizza le mappature predefinite del plugin per `<CR>` (newline intelligente) e `<BS>`
   (cancellazione intelligente della coppia), dato che `map_cr` e `map_bs` non sono
   stati impostati a `false`.

Dependencies:
  - nvim-treesitter: (Richiesto implicitamente per `check_ts = true` e `ts_conds`).
  - nvim-cmp: (Integrazione configurata per `confirm_done`).
  - (Implicit) sphynx.config: (Utilizzato per la lista `disable_filetype`).

Keymaps:
 - Nessuna mappatura personalizzata definita in questa configurazione specifica.
   Vengono utilizzate le funzionalità predefinite associate a `<CR>`, `<BS>`, e
   all'inserimento dei caratteri di coppia.

TODO:
 - [ ] Vedere se integrazione con blink.cmp funziona bene
 - [ ] Esplorare/aggiungere regole personalizzate per altri linguaggi o contesti.
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["autopair"] = {
        "windwp/nvim-autopairs",
        lazy = true,
        event = {"InsertEnter"},
    },
}

M.configs = {
    ["autopair"] = function()
        local Rule = require('nvim-autopairs.rule')
        local npairs = require("nvim-autopairs")

        npairs.setup {
            check_ts = true,
            disable_filetype = sphynx.config.excluded_filetypes,
            ts_config = {
                lua = {'string'},-- it will not add pair on that treesitter node
                javascript = {'template_string'},
                java = false,-- don't check treesitter on java
            }
        }

        local ts_conds = require('nvim-autopairs.ts-conds')

        -- press % => %% is only inside comment or string
        npairs.add_rules({
        Rule("%", "%", "lua")
            :with_pair(ts_conds.is_ts_node({'string','comment'})),
        Rule("$", "$", "lua")
            :with_pair(ts_conds.is_not_ts_node({'function'}))
        })

        local cmp_status_ok, cmp = pcall(require, "cmp")
        if cmp_status_ok then
            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { all = "(", tex = "{" })
        end
    end,
}

return M
