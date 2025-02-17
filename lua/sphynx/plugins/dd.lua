local M = {}

M.plugins = {
    ["dd"] = {
        "https://gitlab.com/yorickpeterse/nvim-dd",
        lazy = true,
        name = "dd",
        event = "LspAttach",
    },
}

M.configs = {
    ["dd"] = function()
        require('dd').setup({
            timeout = 4000
        })
    end,
}

return M

