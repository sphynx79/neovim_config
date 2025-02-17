-- NOTE: PLUGIN: goto-preview
-- Quando si apre la preview la posso trattare come una finestra normale
-- Quindi la posso massimizare con [wM]
-- Spostare con [wm<Left>,wm<Right>,wm<Top>,wm<Down>]
-- Oppure posso usare le map di default di vim [<Ctrl-w>H, <Ctrl-w>L, <Ctrl-w>J, <Ctrl-w>K]
-- Alla fine la posso chiudere con tc

-- NOTE:
-- Per vedere attraverso telescope tutte le parti in cui è usata una classe o un metodo uso => tr
-- che richiama lua require('goto-preview').goto_preview_references()

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
            width = 160, -- Width of the floating window
            height = 35, -- Height of the floating window
            default_mappings = false, -- Bind default mappings
            debug = false, -- Print debug information
            opacity = 5, -- 0-100 opacity level of the floating window where 100 is fully transparent.
            force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
            dismiss_on_move = false,
            stack_floating_preview_windows = true,
            preview_window_title = { enable = true, position = "left" },
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").add({
        { "t", group = " Tags" },
        { "to", [[<Cmd>lua require('goto-preview').goto_preview_definition()<CR>]], desc = "Preview LSP goto definition [goto-preview]" },
        { "tc", [[<Cmd>lua require('goto-preview').close_all_win()<CR>]], desc = "Close all Preview LSP goto definition [goto-preview]" },
        { "tC", [[<Cmd>lua require('goto-preview').close_all_win({ skip_curr_window = true })<CR>]], desc = "Close other Preview LSP goto definition [goto-preview]" },
        { "tr", [[<Cmd>lua require('goto-preview').goto_preview_references()<CR>]], desc = "Preview LSP show all references in telescope [goto-preview]" },
    })
end


return M

