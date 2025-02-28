local M = {}

M.plugins = {
    ["one-small-step-for-vimkind"] = {
        "jbyuki/one-small-step-for-vimkind",
        lazy = false,
        module = "osv",
    },
}

-- M.setup = {
--     ["dap"] = function()
--         require"osv"
--     end
-- }

return M

