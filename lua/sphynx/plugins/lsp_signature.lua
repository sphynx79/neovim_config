local M = {}

M.plugins = {
    ["lsp_signature"] = {
        "ray-x/lsp_signature.nvim",
        lazy = true,
        -- event = "LspAttach",
        event = "VeryLazy",
    },
}

-- M.setup = {
--     ["X"] = function()

--     end,
-- }

M.configs = {
    ["lsp_signature"] = function()
        require'lsp_signature'.setup({
            bind = true,
            noice = true,
            transparency = 20,
            handler_opts = {
                border = "rounded"
            }

        })

    end,
}

return M

