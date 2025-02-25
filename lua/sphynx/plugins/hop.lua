local M = {}

M.plugins = {
    ["hop"] = {
        "smoka7/hop.nvim",
        lazy = true,
        name = 'hop',
        -- keys = {"è","ò","à","f"},
    },
}

M.setup = {
    ["hop"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["hop"] = function()
        require('hop').setup { keys = 'qwertyuiopasdfghjklzxcvbnm' }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    wk.add({
        { "<leader>h", group = "󰋟 Hop" },
    })
    mapping.register({
        {
            mode = { "n"},
            lhs = "<leader>hh",
            rhs = [[<Cmd>lua require'hop'.hint_words()<CR>]],
            options = {silent = true },
            description = "Easymotion current buffer",
        },
        {
            mode = { "n"},
            lhs = "<leader>h<UP>",
            rhs = [[<Cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<CR>]],
            options = {silent = true },
            description = "Easymotion next and previeous current window",
        },
        {
            mode = { "n"},
            lhs = "<leader>h<DOWN>",
            rhs = [[<Cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<CR>]],
            options = {silent = true },
            description = "Easymotion next all",
        },
        {
            mode = { "n"},
            lhs = "<leader>hs",
            rhs = [[<Cmd>lua require'hop'.hint_patterns()<CR>]],
            options = {silent = true },
            description = "Easymotion search word",
        },
        {
            mode = { "n"},
            lhs = "<leader>hH",
            rhs = [[<Cmd>lua require'hop'.hint_words({ multi_windows = true })<CR>]],
            options = {silent = true },
            description = "Easymotion next and previeous all window",
        },
        {
            mode = { "n"},
            lhs = "f",
            rhs = [[<Cmd>lua require'hop'.hint_words({ current_line_only = true })<CR>]],
            options = {silent = true },
            description = "Easymotion word in current line",
        },
        -- {
        --     mode = { "n"},
        --     lhs = "ò",
        --     rhs = [[<Cmd>lua require'hop'.hint_char2()<CR>]],
        --     options = {silent = true },
        --     description = "Easymotion all bat ask one char",
        -- },
        -- {
        --     mode = { "n"},
        --     lhs = "à",
        --     rhs = [[<Cmd>lua require'hop'.hint_patterns()<CR>]],
        --     options = {silent = true },
        --     description = "Easymotion all bat ask wat search",
        -- },
        -- {
        --     mode = { "n"},
        --     lhs = "ù",
        --     rhs = [[<Cmd>lua require'hop'.hint_lines_skip_whitespace()<CR>]],
        --     options = {silent = true },
        --     description = "Easymotion jump to line",
        -- },
    })
end

return M

