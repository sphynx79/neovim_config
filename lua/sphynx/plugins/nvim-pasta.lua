local M = {}

M.plugins = {
    ["nvim-pasta"] = {
        "hrsh7th/nvim-pasta",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["nvim-pasta"] = function()
        vim.keymap.set({ 'n', 'x' }, 'p', require('pasta.mapping').p)
        vim.keymap.set({ 'n', 'x' }, 'P', require('pasta.mapping').P)
    end,
}

return M

