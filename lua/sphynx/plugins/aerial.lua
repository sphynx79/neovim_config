local M = {}

M.plugins = {
    ["aerial"] = {
        "stevearc/aerial.nvim",
        lazy = true,
        cmd = { "AerialToggle", "AerialNavToggle", "AerialOpen" },
    },
}

M.setup = {
    ["aerial"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["aerial"] = function()
        require("aerial").setup({})
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = {"n"},
            lhs = "<F7>",
            rhs = [[<Cmd>AerialToggle<CR>]],
            options = {silent = true },
            description = "Open vista Tag-LSP list",
        },
    })
    -- require("which-key").register({
    --     p = {
    --         name = "󰏗 Plugin",
    --         s = { function()
    --                     require("lazy").load({ plugins = { "symbols-outline.nvim" } })
    --                     vim.cmd([[SymbolsOutline]])
    --               end, "Symbols_outline"},
    --     },
    -- }, mapping.opt_plugin)
end

return M

