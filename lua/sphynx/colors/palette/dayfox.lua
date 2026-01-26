local M = {}

M.palette = function()
    local palette = require('nightfox.palette').load("dayfox")
    return palette
end

-- Otteniamo il valore della palette
local palette = M.palette()

M.colors = {
    bg        = palette.bg0,          -- sfondo chiaro
    bg1       = palette.bg1,
    fg        = palette.fg0,          -- testo scuro
    red       = palette.red.base,
    orange    = palette.orange.base,
    yellow    = palette.yellow.base,
    blue      = palette.blue.base,
    green     = palette.green.base,
    cyan      = palette.cyan.base,
    magenta   = palette.magenta.base,
    pink      = palette.pink.base,
    -- Per tema light: grey bassi = scuri (testo), grey alti = chiari (sfondo)
    grey1     = "#352c24",            -- molto scuro (testo)
    grey2     = "#4a4049",
    grey3     = "#5c5364",
    grey4     = "#6e6679",
    grey5     = "#80798e",
    grey6     = "#9590a0",
    grey7     = "#a8a4b2",
    grey8     = "#bbb8c4",
    grey9     = "#ccc9d3",
    grey10    = "#d8d5dd",
    grey11    = "#e4e1e7",            -- chiaro (sfondo tabline)
    grey12    = "#ebe8ee",            -- più chiaro
    grey13    = "#f2eff5",
    grey14    = "#f5f3f7",
    grey15    = "#f8f6fa",
    grey16    = "#faf9fc",
    grey17    = "#fcfbfd",
    grey18    = "#fdfcfe",
    grey19    = "#fefeff",            -- quasi bianco
    dark_pink = "#E44675",
}

return M
