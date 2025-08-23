local M = {}

M.plugins = {
    ["lspsaga"] = {
        "nvimdev/lspsaga.nvim",
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
    },
}

-- M.setup = {
--     ["X"] = function()

--     end,
-- }

M.configs = {
    ["lspsaga"] = function()
        require('lspsaga').setup({})
    end,
}

-- M.keybindings = function()
--     local mapping = require("sphynx.core.5-mapping")
--     mapping.register({
--         {
--             mode = { "n"},
--             lhs = "key",
--             rhs = [[<Cmd>.....<CR>]],
--             options = {silent = true },
--             description = "Desc",
--         },
--     })
--     require("which-key").register({
--         x = {
--             name = " Todo",
--             q = {[[<Cmd>......<CR>]], "Desc"},
--         },
--     }, mapping.opt_plugin)
-- end

return M

