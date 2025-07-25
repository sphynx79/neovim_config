local M = {}

M.plugins = {
    ["maximizer"] = {
        "declancm/maximize.nvim",
        lazy = true,
    },
}

M.setup = {
    ["maximizer"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["maximizer"] = function()
        require('maximize').setup({
            plugins = {
                aerial = { enable = false }, -- enable aerial.nvim integration
                dapui = { enable = false },  -- enable nvim-dap-ui integration
                tree = { enable = true },   -- enable nvim-tree.lua integration
            }
        })
    end,
}

M.keybindings = function()
    require("which-key").add({
        { "w", group = "󰆏 Window" },
        { "wM", [[<CMD>lua require('maximize').toggle()<CR>]], desc = "Maximize [maximize.nvim]"},
    })

end

return M
