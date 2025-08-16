local M = {}

M.plugins = {
    ["sayonara"] = {
        "mhinz/vim-sayonara",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["sayonara"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["sayonara"] = function()

    end,
}

M.keybindings = function()
    -- nmap bc :Sayonara!<CR>
    vim.keymap.set("n", "bc", "<cmd>Sayonara!<CR>", { silent = true, desc = "Close buffer [Sayonara]" })

    -- nmap bC :Sayonara<CR>
    vim.keymap.set("n", "bC", "<cmd>Sayonara<CR>",  { silent = true, desc = "Close buffer and window [Sayonara]" })
end

return M

