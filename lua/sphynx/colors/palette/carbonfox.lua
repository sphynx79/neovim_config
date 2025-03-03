local M = {}

M.palette = function()
    local palette = require('nightfox.palette').load("carbonfox")
    return palette
end

-- Otteniamo il valore della palette
local palette = M.palette()

M.colors = {
    bg        = palette.bg0,                -- #131a24
    bg1       = palette.bg1,                -- #192330
    fg        = palette.fg0,                -- #d6d6d7
    red       = palette.red.base,           -- #c94f6d
    orange    = palette.orange.base,        -- #f4a261
    yellow    = palette.yellow.base,        -- #dbc074
    blue      = palette.blue.base,          -- #719cd6
    green     = palette.green.base,         -- #81b29a
    cyan      = palette.cyan.base,          -- #63cdcf
    magenta   = palette.magenta.base,       -- #9d79d6
    pink      = palette.pink.base,          -- #d67ad2
    dark_pink = "#E44675",
    grey1     = "#f8fafc",
    grey2     = "#f0f1f4",
    grey3     = "#eaecf0",
    grey4     = "#d9dce3",
    grey5     = "#c4c9d4",
    grey6     = "#b5bcc9",
    grey7     = "#929cb0",
    grey8     = "#8e99ae",
    grey9     = "#74819a",
    grey10    = "#616d85",
    grey11    = "#464f62",
    grey12    = "#3a4150",
    grey13    = "#0C0C0C",
    grey14    = "#242932",
    grey15    = "#1e222a",
    grey16    = "#1c1f26",
    grey17    = "#0f1115",
    grey18    = "#0d0e11",
    grey19    = "#020203",
}

return M
