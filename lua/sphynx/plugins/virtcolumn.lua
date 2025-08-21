local M = {}

M.plugins = {
    ["virtcolumn"] = {
        "lukas-reineke/virt-column.nvim",
        lazy = true,
        event = "BufReadPost",
    },
}

M.configs = {
    ["virtcolumn"] = function()
        require("virt-column").setup({
            char = '▕',
            virtcolumn = "100",
            highlight = "VirtColumn"
        })
    end,
}

return M

