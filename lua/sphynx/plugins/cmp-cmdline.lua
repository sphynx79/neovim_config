local M = {}

M.plugins = {
    ["cmp_cmdline"] = {
        "hrsh7th/cmp-cmdline",
        lazy = true,
        event = {"CmdlineEnter"},
    },
}

return M
