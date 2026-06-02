--[[
===============================================================================================
Plugin: nvim-comment
===============================================================================================
Description: Commenta e decommenta righe singole e selezioni visuali, scegliendo
             automaticamente il "commentstring" giusto in base al filetype.
Status: Active
Author: terrortylor
Repository: https://github.com/terrortylor/nvim-comment
Notes:
 - Caricamento lazy tramite il comando :CommentToggle (cmd trigger); le keybinding sono
   registrate all'avvio via M.setup.
 - create_mappings = false: le mappature di default del plugin sono disattivate e gestite
   qui manualmente.
 - comment_empty = false: non commenta le righe vuote o composte solo da spazi.
 - Il modulo Lua e' "nvim_comment" (underscore), mentre il repo e' "nvim-comment" (trattino).
 - La keymap usa ":CommentToggle<CR>" (non <Cmd>): in visual mode Vim prepone in automatico
   il range '<,'>, quindi commenta correttamente la selezione.
Keymaps:
 - <localleader>. (normale e visuale) → CommentToggle (commenta riga o selezione)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["comment"] = {
        "terrortylor/nvim-comment",
        lazy = true,
        cmd = "CommentToggle",
        -- keys = {"<localleader>."},
    },
}

M.setup = {
    ["comment"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["comment"] = function()
        require("nvim_comment").setup({
            create_mappings = false,
            -- should comment out empty or whitespace only lines
            comment_empty = false,
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    -- vim.keymap.set("n", "<localleader>.", ":CommentToggle <CR>")
    mapping.register({
        {
            mode = { "n", "v" },
            lhs = "<localleader>.",
            rhs = ":CommentToggle <CR>",
            options = { silent = true },
            description = "Comment line",
        },
    })
end

return M
