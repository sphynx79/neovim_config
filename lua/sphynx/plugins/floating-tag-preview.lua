local M = {}

M.plugins = {
    ["floating_tag_preview"] = {
        "weilbith/nvim-floating-tag-preview",
        lazy = true,
        cmd = {"Ptag", "Ptselect", "Ptjump", "Psearch", "Pedit" },
    },
}

M.setup = {
    ["floating_tag_preview"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["floating_tag_preview"] = function()
        vim.g.floating_tag_preview_height = 40
        vim.g.floating_tag_preview_width = 120
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").add({
        { "t", group = " Tags" },
        { "tp", [[<Esc>:exe "Ptjump " . expand("<cword>")<CR>]], desc = "Tag Preview [float-tag-preview]" },
    })
end

return M
