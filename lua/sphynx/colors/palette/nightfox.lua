local M = {}

M.palette = function()
    local palette = require('nightfox.palette').load("nightfox")
    return palette
end

M.colors = {
    bg        = "#131a24",
    bg1       = "#192330",
    fg        = "#ECEFF4",
    red       = "#c94f6d",
    orange    = "#f4a261",
    yellow    = "#dbc074",
    blue      = "#719cd6",
    green     = "#81b29a",
    cyan      = "#63cdcf",
    magenta   = "#9d79d6",
    pink      = "#d67ad2",
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
    grey13    = "#1E2530",
    grey14    = "#131A24",
    grey15    = "#0D1218",
    grey16    = "#0E141B",
    grey17    = "#0B0F15",
    grey18    = "#070A0E",
    grey19    = "#040507",
    dark_pink = "#E44675",
}

return M
