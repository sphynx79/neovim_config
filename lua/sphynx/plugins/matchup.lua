local M = {}

M.plugins = {
    ["matchup"] = {
        "andymass/vim-matchup",
        lazy = true,
        event = "CursorMoved",
    },
}

M.configs = {
    ["matchup"] = function()
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_deferred_show_delay = 450
        vim.g.matchup_delim_noskips = 2
        vim.g.matchup_matchparen_pumvisible = 1
        vim.g.matchup_motion_cursor_end = 0
        vim.g.matchup_matchparen_nomode = 'i'
        vim.g.matchup_matchparen_timeout = 250
        vim.g.matchup_matchparen_insert_timeout = 40
        vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        vim.cmd([[hi MatchParen ctermbg=blue guibg=#5c6370 cterm=italic gui=italic]])
    end,
}

return M

