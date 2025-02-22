local M = {}



M.palette = function()
    local palette = require('nightfox.palette').load("nordfox")
    return palette
end

M.colors = {
    bg        = "#e4dcd4",
    bg1       = "#ECEFF4",
    fg        = "#ECEFF4",
    red       = "#a5222f",
    orange    = "#955f61",
    yellow    = "#AC5402",
    blue      = "#2848a9",
    green     = "#a3be8c",
    cyan      = "#287980",
    magenta   = "#6e33ce",
    pink      = "#a440b5",
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
    grey13    = "#E9E0D9",
    grey14    = "#242932",
    grey15    = "#1e222a",
    grey16    = "#1c1f26",
    grey17    = "#0f1115",
    grey18    = "#0d0e11",
    grey19    = "#020203",
    dark_pink = "#E44675",
}

return M
