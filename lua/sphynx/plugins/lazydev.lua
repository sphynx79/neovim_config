local M = {}

M.plugins = {
    ["lazydev"] = {
        "folke/lazydev.nvim",
        ft = "lua",
        lazy = true,
        dependencies = { "Bilal2453/luvit-meta", lazy = true }
    },
}

M.configs = {
    ["lazydev"] = function()
        require('lazydev').setup({
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                "lazy.nvim",
                vim.env.VIMRUNTIME,
                unpack(vim.api.nvim_get_runtime_file("lua/vim", true)),
            },
        })
    end,
}


return M
