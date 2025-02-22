local M = {}

M.palette = function()
    local palette = require('nightfox.palette').load("nightfox")
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
    grey2     = "#DEE0E4",
    grey3     = "#C3C7CC",
    grey4     = "#A9ADB4",
    grey5     = "#8F949C",
    grey6     = "#757A84",
    grey7     = "#5A616F",
    grey8     = "#525966",
    grey9     = "#343C48",
    grey10    = "#434A55",
    grey11    = "#3C424C",
    grey12    = "#29313C",
    grey13    = "#101C29",
    grey14    = "#131A24",
    grey15    = "#0D1218",
    grey16    = "#0E141B",
    grey17    = "#0B0F15",
    grey18    = "#070A0E",
    grey19    = "#040507",
}

return M
