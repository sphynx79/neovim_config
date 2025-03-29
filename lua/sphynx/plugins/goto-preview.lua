-- NOTE: PLUGIN: goto-preview

-- NOTE:
-- Per vedere attraverso telescope tutte le parti in cui è usata una classe o un metodo uso => tr
-- che richiama lua require('goto-preview').goto_preview_references()

--[[
===============================================================================================
Plugin: goto-preview
===============================================================================================
Description: Visualizza in finestre flottanti le anteprime dei risultati delle funzioni LSP
             come definizione, implementazione e riferimenti.
Status: Active
Author: rmagatti
Repository: https://github.com/rmagatti/goto-preview
Notes:
 - Quando si apre la preview la posso trattare come una finestra normale
 - Quindi la posso massimizare con [wM]
 - Spostare con [wm<Left>,wm<Right>,wm<Top>,wm<Down>]
 - Oppure posso usare le map di default di vim [<Ctrl-w>H, <Ctrl-w>L, <Ctrl-w>J, <Ctrl-w>K]
 - Alla fine la posso chiudere con tc

Differenze tra funzionalità LSP:
 - Definition: Mostra dove un simbolo è effettivamente definito/implementato
   Esempio: Dove è scritta l'implementazione di una funzione

 - Type Definition: Mostra la definizione del tipo di dato di un simbolo
   Esempio: Se hai una variabile 'user' di tipo 'User', ti porta alla definizione della classe 'User'

 - Implementation: Mostra tutte le implementazioni concrete di un'interfaccia o classe astratta
   Esempio: Tutte le classi che implementano un'interfaccia

 - Declaration: Mostra dove un simbolo è dichiarato (può essere diverso da dove è definito)
   Esempio: In C/C++, una funzione può essere dichiarata in un header (.h) e definita in un .c

 - References: Mostra tutti i punti nel codice dove un simbolo viene utilizzato
   Esempio: Tutti i luoghi dove viene chiamata una certa funzione

Keymaps:
 - td                      → Mostra anteprima della definizione LSP
 - tt                      → Mostra anteprima della type definition LSP
 - tD                      → Mostra anteprima della dichiarazione LSP
 - ti                      → Mostra anteprima dell'implementazione LSP
 - tr                      → Mostra tutti i riferimenti in una finestra telescope
 - tc                      → Chiude tutte le finestre di anteprima
 - tC                      → Chiude tutte le finestre di anteprima tranne quella corrente

TODO:
 - [ ] Valutare l'integrazione con altri provider oltre a telescope per i riferimenti
 - [ ] Considerare l'aggiunta di opzioni di personalizzazione per i bordi delle finestre
===============================================================================================
--]]



local M = {}

M.plugins = {
    ["goto_preview"] = {
        "rmagatti/goto-preview",
        lazy = true,
    },
}

M.setup = {
    ["goto_preview"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["goto_preview"] = function()
        require('goto-preview').setup {
            width = 160,
            height = 35,
            default_mappings = false,
            debug = false,
            opacity = 5,
            force_close = true,
            dismiss_on_move = false,
            stack_floating_preview_windows = true,
            preview_window_title = { enable = true, position = "left" },
        }
    end,
}

M.keybindings = function()
    require("which-key").add({
        { "t", group = " Tags" },
        { "td", [[<Cmd>lua require('goto-preview').goto_preview_definition()<CR>]], desc = "Preview LSP goto definition [goto-preview]" },
        { "tt", [[<Cmd>lua require('goto-preview').goto_preview_type_definition()<CR>]], desc = "Preview LSP goto type definition [goto-preview]" },
        { "tD", [[<Cmd>lua require('goto-preview').goto_preview_declaration()<CR>]], desc = "Preview LSP goto declaration [goto-preview]" },
        { "ti", [[<Cmd>lua require('goto-preview').goto_preview_implementation()<CR>]], desc = "Preview LSP goto implementation [goto-preview]" },
        { "tr", [[<Cmd>lua require('goto-preview').goto_preview_references()<CR>]], desc = "Preview LSP show all references in telescope [goto-preview]" },
        { "tc", [[<Cmd>lua require('goto-preview').close_all_win()<CR>]], desc = "Close all Preview LSP goto definition [goto-preview]" },
        { "tC", [[<Cmd>lua require('goto-preview').close_all_win({ skip_curr_window = true })<CR>]], desc = "Close other Preview LSP goto definition [goto-preview]" },
    })
end

return M
