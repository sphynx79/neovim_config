local M = {}

M.plugins = {
    ["lsp_smag"] = {
        "weilbith/nvim-lsp-smag",
        lazy = true,
        event = "VeryLazy",
    },
}

return M
