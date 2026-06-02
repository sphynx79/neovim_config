--[[
===============================================================================================
Plugin: marks.nvim
===============================================================================================
Description: Potenzia i mark nativi di Vim: mostra i mark nella signcolumn, permette di
             aggiungere/cancellare/navigare/preview dei mark e introduce i "bookmark"
             (marcatori senza nome, con sign e annotazioni, anche cross-buffer).
Status: Active
Author: chentoast (Tony Chen)
Repository: https://github.com/chentoast/marks.nvim
Notes:
 - lazy = false: attivo fin dall'avvio per tracciare i mark e disegnare i signs.
 - default_mappings = false: niente mapping nativi del plugin; tutto rimappato sotto
   <leader>m tramite i <Plug> mapping di marks.nvim.
 - cyclic = true: la navigazione tra mark cicla a inizio/fine buffer.
 - force_write_shada = true: ATTENZIONE, opzione "destructive" - cancellare un mark globale
   (maiuscolo) lo rimuove in modo permanente anche dallo shada file.
 - refresh_interval = 250 (default 150): meno frequente = meno lag, mark un filo meno reattivi.
 - sign_priority per tipo di mark; bookmark groups 0/1/2 con sign custom e annotate = true
   (chiede un'annotazione quando si imposta il bookmark).
 - NOTA: il set-mark nativo "m" e' intercettato dal trigger { "m", mode = "n" } in
   which-key.lua; qui i comandi vivono tutti sotto <leader>m.
Keymaps (<leader>m = Marks):
 - <leader>m<Down> → mark successivo      - <leader>m<Up>    → mark precedente
 - <leader>m<Right> → set next available  - <leader>mt       → toggle mark
 - <leader>md → delete mark sulla riga    - <leader>mD       → delete mark nel buffer
 - <leader>mp → preview mark              - <leader>ml / mL  → lista mark buffer / globali (QF)
 - <leader>mb → bookmarks: mbd delete bookmark sotto cursore, mb0..mb9 set bookmark gruppo N
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["marks"] = {
        "chentoast/marks.nvim",
        name = "marks",
        lazy = false,
        -- keys = {"<leader>m", "m"},
    },
}

M.setup = {
    ["marks"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["marks"] = function()
        require("marks").setup({
            -- whether to map keybinds or not. default true
            default_mappings = false,
            -- which builtin marks to show. default {}
            builtin_marks = {},
            -- whether movements cycle back to the beginning/end of buffer. default true
            cyclic = true,
            -- whether the shada file is updated after modifying uppercase marks. default false
            force_write_shada = true,
            -- how often (in ms) to redraw signs/recompute mark positions.
            -- higher values will have better performance but may cause visual lag,
            -- while lower values may cause performance penalties. default 150.
            refresh_interval = 250,
            -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
            -- marks, and bookmarks.
            -- can be either a table with all/none of the keys, or a single number, in which case
            -- the priority applies to all marks.
            -- default 10.
            sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
            -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
            -- sign/virttext. Bookmarks can be used to group together positions and quickly move
            -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
            -- default virt_text is "".
            bookmark_0 = {
                sign = "⚑",
                annotate = true,
            },
            bookmark_1 = {
                sign = "",
                annotate = true,
            },
            bookmark_2 = {
                sign = "",
                annotate = true,
            },
            mappings = {},
        })
    end,
}

M.keybindings = function()
    require("which-key").add({
        { "<leader>m", group = " Marks" },
        { "<leader>m<Down>", [[<Plug>(Marks-next)]], desc = "go next" },
        { "<leader>m<Up>", [[<Plug>(Marks-prev)]], desc = "go prev" },
        { "<leader>m<Right>", [[<Plug>(Marks-setnext)]], desc = "set next available" },
        { "<leader>md", [[<Plug>(Marks-deleteline)]], desc = "delete in current line" },
        { "<leader>mD", [[<Plug>(Marks-deletebuf)]], desc = "delete in all buffer" },
        { "<leader>mt", [[<Plug>(Marks-toggle)]], desc = "toggle" },
        { "<leader>mp", [[<Plug>(Marks-preview)]], desc = "preview mark input" },
        { "<leader>ml", [[<Cmd>MarksQFListBuf<CR>]], desc = "list buffer marks" },
        { "<leader>mL", [[<Cmd>MarksQFListGlobal<CR>]], desc = "list global marks" },
        { "<leader>mb", group = "bookmarks" },
        { "<leader>mbd", "<Plug>(Marks-delete-bookmark)", desc = "delete bookmark line" },
        { "<leader>mb#", desc = "Set bookmark .N" },
    })
    for i = 0, 9 do
        require("which-key").add({
            { "<leader>mb" .. tostring(i), "<Plug>(Marks-set-bookmark" .. tostring(i) .. ")", hidden = true },
        })
    end
end

return M
