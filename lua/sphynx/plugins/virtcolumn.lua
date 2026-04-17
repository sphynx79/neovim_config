local M = {}

M.plugins = {
    ["virtcolumn"] = {
        "sphynx79/virt-column.nvim",
        lazy = true,
        event = "BufReadPost",
        pin = true,
        commit = "7c12ad40adbb7ebcecbe72942c42837b66fe5985",
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
