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
    end
}

M.configs = {
    ["marks"] = function()
        require('marks').setup {
            -- whether to map keybinds or not. default true
            default_mappings = false,
            -- which builtin marks to show. default {}
            builtin_marks = { },
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
            sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
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
            mappings = {}
        }
    end
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
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
        { "<leader>mb" .. tostring(i),  "<Plug>(Marks-set-bookmark" .. tostring(i) .. ")", hidden = true },
      })
    end

    -- require("which-key").add({
    --     { "m", group = " Marks" },
    --     { "m<Down>", [[<Plug>(Marks-next)]], desc = "go next" },
    --     { "m<Up>", [[<Plug>(Marks-prev)]], desc = "go prev" },
    --     { "m,", [[<Plug>(Marks-setnext)]], desc = "set next available" },
    --     { "m.", [[<Plug>(Marks-deleteline)]], desc = "del current line marks" },
    --     { "m-", [[<Cmd>MarksQFListBuf<CR>]], desc = "list buffer marks" },
    --     { "mb", group = "bookmarks" },
    --     { "mb<Up>", [[<Plug>(Marks-prev-bookmark)]], desc = "go to prev bookmark same group" },
    --     { "mb<Down>", [[<Plug>(Marks-next-bookmark)]], desc = "go to next bookmark same group" },
    --     { "mb0", [[<Plug>(Marks-set-bookmark0)]], desc = "set bookmarks group0" },
    --     { "mb1", [[<Plug>(Marks-set-bookmark1)]], desc = "set bookmarks group1" },
    --     { "mb2", [[<Plug>(Marks-set-bookmark2)]], desc = "set bookmarks group2" },
    --     { "mbd", [[<Plug>(Marks-delete-bookmark)]], desc = "delete bookmark line" },
    -- })
end

return M

