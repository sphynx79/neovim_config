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
        vim.g.neoformat_enabled_typescript = { "tsfmt" }

        -- Bash/shell: formatta con shfmt
        -- Neovim puo' classificare i file .sh come filetype "sh" oppure "bash"
        -- (a seconda dello shebang): definiamo la config per entrambi.
        local shfmt = {
            exe = "shfmt.exe",
            args = { "-i", "4", "-ci", "-bn", "-sr" },
            stdin = 1,
        }
        vim.g.neoformat_sh_shfmt = shfmt
        vim.g.neoformat_bash_shfmt = shfmt
        vim.g.neoformat_enabled_sh = { "shfmt" }
        vim.g.neoformat_enabled_bash = { "shfmt" }

        M.keybindings()
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n" },
            lhs = "<F8>",
            rhs = [[<Cmd>Neoformat<CR>]],
            options = { silent = true },
            description = "Format code",
        },
        {
            mode = { "n", "v" },
            lhs = "<F8>",
            rhs = [[<Cmd>Neoformat<CR>gv]],
            options = { silent = true },
            description = "Format code",
        },
    })
end

return M
