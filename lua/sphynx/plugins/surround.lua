local M = {}

M.plugins = {
    ["surround"] = {
        "kylechui/nvim-surround",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["surround"] = function()
        require("nvim-surround").setup({
            move_cursor = "sticky", -- il cursore resta sul carattere su cui eri, non salta all'inizio dell'azione
        })
    end,
}

return M
