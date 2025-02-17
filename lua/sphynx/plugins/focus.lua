local M = {}

M.plugins = {
    ["focus"] = {
        "beauwilliams/focus.nvim",
        opt = true,
        as = "focus",
        module = "focus",
    },
}

M.setup = {
    ["focus"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["focus"] = function()
        require("focus").setup {
            enable = true,
            excluded_filetypes = sphynx.config.excluded_filetypes,
            excluded_buftypes = {"help"},
            treewidth = 30,
            signcolumn = false,
            number = false,
            winhighlight = false,
            minwidth = 30,
            -- height = 20,
            -- width = 100,
            cursorline = false,
            relativenumber = false,
            hybridnumber = false,
            -- compatible_filetrees = { 'nvimtree', 'NvimTree', 'chadtree', 'fern' },
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").register({
        f = {
            name = " Focus",
            e = {[[<Cmd>lua require('focus').focus_enable()<CR>]], "enable"},
            d = {[[<Cmd>lua require('focus').focus_disable()<CR>]], "disable"},
            t = {[[<Cmd>lua require('focus').focus_toggle()<CR>]], "toggle"},
            M = {[[<Cmd>lua require('focus').focus_maximise()<CR>]], "maximize"},
            m = {[[<Cmd>lua require('focus').focus_equalise()<CR>]], "toggle maximize"},
            ["="] = {[[<Cmd>lua require('focus').focus_max_or_equal()<CR>]], "equalize"},
        },
    }, mapping.opt_plugin)
end

return M

