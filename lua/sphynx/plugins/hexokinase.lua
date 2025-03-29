local M = {}

M.plugins = {
    ["hexokinase"] = {
        "rrethy/vim-hexokinase",
        lazy = true,
        build = "make hexokinase",
        cmd = {'HexokinaseTurnOn', 'HexokinaseToggle'},
    },
}

M.setup = {
    ["hexokinase"] = function()
        vim.g.Hexokinase_ftEnabled = {'scss', 'css', 'html', 'javascript', 'vim', 'lua'}
        -- possible value: 'virtual', 'sign_column', 'background', 'backgroundfull','foreground','foregroundfull'
        vim.g.Hexokinase_highlighters = { 'virtual' }
        vim.g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla'
        vim.g.Hexokinase_refreshEvents = {'BufWritePost'}

        M.keybindings()
    end,
}

M.keybindings = function()
    local wk = require("which-key")

    wk.add({
        { "<leader>c", group = " Colors" },
        { "<leader>ce", [[<Cmd>HexokinaseTurnOn<CR>]], desc = "Enable" },
        { "<leader>ct", [[<Cmd>HexokinaseToggle<CR>]], desc = "Toogle" },
        { "<leader>cd", [[<Cmd>HexokinaseTurnOff<CR>]], desc = "Disable" },
    })
end

return M
