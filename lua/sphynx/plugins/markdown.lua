local M = {}

M.plugins = {
    ["markdown"] = {
        "plasticboy/vim-markdown",
        lazy = true,
        dependencies = "godlygeek/tabular",
        ft = "markdown",
    },
}

return M
