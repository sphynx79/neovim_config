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
    end
}

M.configs = {
    ["comment"] = function()
        require("nvim_comment").setup {
            create_mappings = false,
            -- should comment out empty or whitespace only lines
            comment_empty = false,
        }
    end,
}

M.keybindings = function()
        local mapping = require("sphynx.core.5-mapping")
        -- vim.keymap.set("n", "<localleader>.", ":CommentToggle <CR>")
        mapping.register({
            {
                mode = { "n", "v"},
                lhs = "<localleader>.",
                rhs = ":CommentToggle <CR>",
                options = { silent = true },
                description = "Comment line",
            },
        })
end

return M

