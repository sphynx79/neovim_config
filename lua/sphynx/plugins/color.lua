local M = {}

M.plugins = {
    ["color"] = {
        "eero-lehtinen/oklch-color-picker.nvim",
        event = "VeryLazy",
    },
}

M.setup = {
    ["color"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["color"] = function()
        require("oklch-color-picker").setup {
            highlight = {
                enabled = false,
                -- List of LSP clients that are allowed to highlight colors:
                -- By default, only fairly performant and useful LSPs are enabled.
                -- Set `enabled_lsps = true` to enable all LSPs anyways.
                enabled_lsps = { "tailwindcss", "cssls", "css_variables" }
            }
        }
    end,
}

M.keybindings = function()
    local wk = require("which-key")

    wk.add({
        { "<leader>c", group = " Colors" },
        { "<leader>ce", [[<Cmd>lua require("oklch-color-picker").highlight.enable()<CR>]], desc = "Enable" },
        { "<leader>ct", [[<Cmd>lua require("oklch-color-picker").highlight.toggle()<CR>]], desc = "Toogle" },
        { "<leader>cd", [[<Cmd>lua require("oklch-color-picker").highlight.disable()<CR>]], desc = "Disable" },
        { "<leader>cp", [[<Cmd>lua require('oklch-color-picker').pick_under_cursor()<CR>]], desc = "Pick color" },
    })
end

return M
