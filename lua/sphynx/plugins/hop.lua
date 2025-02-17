local M = {}

M.plugins = {
    ["hop"] = {
        "phaazon/hop.nvim",
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
    mapping.register({
        {
            mode = { "n"},
            lhs = "à",
            rhs = [[<Cmd>lua require'hop'.hint_words()<CR>]],
            options = {silent = true },
            description = "Easymotion next and previeous all",
        },
        {
            mode = { "n"},
            lhs = "ò",
            rhs = [[<Cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<CR>]],
            options = {silent = true },
            description = "Easymotion previeous all",
        },
        {
            mode = { "n"},
            lhs = "ù",
            rhs = [[<Cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<CR>]],
            options = {silent = true },
            description = "Easymotion next all",
        },
        {
            mode = { "n"},
            lhs = "è",
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

