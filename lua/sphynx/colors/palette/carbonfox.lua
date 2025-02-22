local M = {}

M.palette = function()
    local palette = require('nightfox.palette').load("carbonfox")
    return palette
end

-- Otteniamo il valore della palette
local palette = M.palette()

M.colors = {
    bg        = palette.bg0,
    bg1       = palette.bg1,
    fg        = palette.fg0,
    red       = palette.red.base,
    orange    = palette.orange.base,
    yellow    = palette.yellow.base,
    blue      = palette.blue.base,
    green     = palette.green.base,
    cyan      = palette.cyan.base,
    magenta   = palette.magenta.base,
    pink      = palette.pink.base,
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
