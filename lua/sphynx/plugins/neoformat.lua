local M = {}

M.plugins = {
    ["neoformat"] = {
        "sbdchd/neoformat",
        lazy = true,
        cmd = { "Neoformat" },
        -- TODO: vedere se per alcuni file usare prettier/vim-prettier vedere il file config che adesso lo ho disabilitato
    },
}

M.setup = {
    ["neoformat"] = function()
        vim.g.neoformat_enabled_typescript = {'tsfmt'}
        M.keybindings()
    end
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "<F8>",
            rhs = [[<Cmd>Neoformat<CR>]],
            options = {silent = true },
            description = "Format code",
        },
        {
            mode = { "n", "v"},
            lhs = "<F8>",
            rhs = [[<Cmd>Neoformat<CR>gv]],
            options = {silent = true },
            description = "Format code",
        },
    })
end

return M

