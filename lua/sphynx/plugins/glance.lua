--[[
===============================================================================================
Plugin: glance.nvim
===============================================================================================
Description: Fornisce una finestra di preview stile VSCode per esplorare definizioni, riferimenti,
             implementazioni e type definitions via LSP senza perdere il contesto attuale.
Status: Active
Author: dnlhc
Repository: https://github.com/dnlhc/glance.nvim
Notes:
 - Mi permettere di modificare il codice nella finstra di preview che si apre
 - Preview integrata o flottante a seconda della larghezza della finestra (auto-detect)
 - Usa highlight disabilitato per evitare distrazioni visive nella preview
 - Focus automatico sulla preview al momento dell'apertura (hook `after_open`)
 - Winbar abilitato nella preview
 - Indent guides attive nella lista
Keymaps:
 - <leader>gd          → Jump to definition
 - <leader>gi          → Jump to implementation
 - <leader>gr          → Jump to references
 - <leader>gt          → Jump to type definitions
 - <C-p>               → Focus preview dalla lista
 - <C-l>               → Focus lista dalla preview
 - <Tab>/<S-Tab>       → Naviga tra i risultati
 - <PageUp/PageDown>   → Scrolla la preview
 - v / s / t           → Apri risultato in vsplit / split / tab
 - q / <Esc> / Q       → Chiudi glance
TODO:
 - [ ] Aggiungere supporto per metodi LSP custom specifici di certi linguaggi
 - [ ] Integrare con trouble.nvim per la gestione alternativa della quickfix list
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["glance"] = {
        "dnlhc/glance.nvim",
        lazy = true,
    },
}

M.setup = {
    ["glance"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["glance"] = function()
        local glance = require('glance')
        local actions = glance.actions

        glance.setup({
            height = 24,
            zindex = 45,
            preserve_win_context = true,
            detached = function(winid)
                return vim.api.nvim_win_get_width(winid) < 100
            end,
            preview_win_opts = {
                cursorline = true,
                number = true,
                wrap = true,
            },
            border = {
                enable = true,
                top_char = '―',
                bottom_char = '―',
            },
            list = {
                position = 'right',
                width = 0.33,
            },
            theme = {
                enable = true,
                mode = 'auto',
            },
            mappings = {
                list = {
                    ['<Down>'] = actions.next,
                    ['<Up>'] = actions.previous,
                    ['<Tab>'] = actions.next_location,
                    ['<S-Tab>'] = actions.previous_location,
                    ['<PageDown>'] = actions.preview_scroll_win(5),
                    ['<PageUp>'] = actions.preview_scroll_win(-5),
                    ['v'] = actions.jump_vsplit,
                    ['s'] = actions.jump_split,
                    ['t'] = actions.jump_tab,
                    ['<CR>'] = actions.jump,
                    ['o'] = actions.jump,
                    ['<C-p>'] = actions.enter_win('preview'),
                    ['q'] = actions.close,
                    ['Q'] = actions.close,
                    ['<Esc>'] = actions.close,
                },
                preview = {
                    ['<Tab>'] = actions.next_location,
                    ['<S-Tab>'] = actions.previous_location,
                    ['<C-l>'] = actions.enter_win('list'),
                    ['q'] = actions.close,
                    ['Q'] = actions.close,
                    ['<Esc>'] = actions.close,
                },
            },
            folds = {
                fold_closed = '󰅂',
                fold_open = '󰅀',
                folded = true,
            },
            indent_lines = {
                enable = true,
                icon = '│',
            },
            winbar = {
                enable = true,
            },
            hooks = {
                after_open = function(results, open, jump, method)
                    -- Focalizza la preview appena si apre
                    vim.defer_fn(function()
                        actions.enter_win("preview")()
                    end, 50)
                end
            },
            use_trouble_qf = false,
        })
        vim.api.nvim_set_hl(0, 'GlancePreviewMatch', {})
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>g"

    wk.add({
        { prefix, group = " Glance" },
        { prefix .. "d", "<Cmd>lua require('glance').open(\"definitions\")<CR>", desc = "definition" },
        { prefix .. "i", "<Cmd>lua require('glance').open(\"implementations\")<CR>", desc = "implementations" },
        { prefix .. "r", "<Cmd>lua require('glance').open(\"references\")<CR>", desc = "references" },
        { prefix .. "t", "<Cmd>lua require('glance').open(\"type_definitions\")<CR>", desc = "type_definitions" },
    }, mapping.opt_mappping)
end

return M
