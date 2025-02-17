local M = {}

M.plugins = {
    ["cybu"] = {
        "ghillb/cybu.nvim",
        lazy = true,
    },
}

M.setup = {
    ["cybu"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["cybu"] = function()
        local ok, cybu = pcall(require, "cybu")
        if not ok then
            return
        end
        cybu.setup({
            position = {
                relative_to = "win",          -- win, editor, cursor
                anchor = "topcenter",            -- topleft, topcenter, topright,
                                              -- centerleft, center, centerright,
                                              -- bottomleft, bottomcenter, bottomright
                vertical_offset = 2,         -- vertical offset from anchor in lines
                horizontal_offset = 0,        -- vertical offset from anchor in columns
                max_win_height = 5,           -- height of cybu window in lines
                max_win_width = 0.5,          -- integer for absolute in columns
                                              -- float for relative to win/editor width
            },
            style = {
                path = "relative",            -- absolute, relative, tail (filename only)
                path_abbreviation = "none",   -- none, shortened
                border = "rounded",           -- single, double, rounded, none
                separator = " ",              -- string used as separator
                prefix = "…",                 -- string used as prefix for truncated paths
                padding = 1,                  -- left & right padding in number of spaces
                hide_buffer_id = true,        -- hide buffer IDs in window
                devicons = {
                    enabled = true,               -- enable or disable web dev icons
                    colored = true,               -- enable color for web dev icons
                    truncate = true,              -- truncate wide icons to one char width
                },
                highlights = {                -- see highlights via :highlight
                    current_buffer = "CybuFocus",       -- current / selected buffer
                    adjacent_buffers = "CybuAdjacent",  -- buffers not in focus
                    background = "CybuBackground",      -- window background
                    border = "CybuBorder",              -- border of the window
                },
            },
            behavior = {                    -- set behavior for different modes
                mode = {
                    default = {
                        switch = "immediate",     -- immediate, on_close
                        view = "rolling",         -- paging, rolling
                    },
                    last_used = {
                        switch = "on_close",      -- immediate, on_close
                        view = "paging",          -- paging, rolling
                    },
                    auto = {
                        view = "rolling",         -- paging, rolling
                    },
                },
                show_on_autocmd = false,      -- event to trigger cybu (eg. "BufEnter")
            },
            display_time = 1000,             -- time the cybu window is displayed
            exclude = {                     -- filetypes, cybu will not be active
                "neo-tree",
                "fugitive",
                "qf",
            },
            fallback = function() end,      -- arbitrary fallback function
        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").add({
        { "b", group = " Buffers" },
        { "b<Right>", [[<CMD>lua require("cybu").cycle("next")<CR>]], desc = "Next buffer" },
        { "b<Left>", [[<CMD>lua require("cybu").cycle("prev")<CR>]], desc = "Prev buffer" },
        { "b<Down>", [[<CMD>lua require("cybu").cycle("next", "last_used")<CR>]], desc = "Next Last buffer" },
        { "b<Up>", [[<CMD>lua require("cybu").cycle("prev", "last_used")<CR>]], desc = "Prev Last Buffer" },
    })
end

return M

