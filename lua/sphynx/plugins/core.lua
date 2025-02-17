local M = {}

M.plugins = {
    ["plenary.nvim"]   = { "nvim-lua/plenary.nvim" },
    ["notify"]         = { "rcarriga/nvim-notify" },
}

-- M.setup = {
--     ["notify"] = function()
--         vim.notify = function(msg, level, opts)
--             vim.notify = require("notify").setup({
--                 timeout = 3000,
--                 max_height = function()
--                     return math.floor(vim.o.lines * 0.75)
--                 end,
--                 max_width = function()
--                     return math.floor(vim.o.columns * 0.75)
--                 end,
--                 on_open = function(win)
--                     vim.api.nvim_win_set_config(win, { zindex = 100 })
--                 end,
--             })
--             vim.notify(msg, level, opts)
--         end
--     end
-- }

return M

