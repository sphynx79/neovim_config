local M = {}

M.palette = function()
    local palette = require('nightfox.palette').load("terafox")
    return palette
end

-- Otteniamo il valore della palette
local palette = M.palette()

M.colors = {
    bg        = palette.bg0,          -- #0f1c1e
    bg1       = palette.bg1,          -- #152528
    fg        = palette.fg0,          -- #eaeeee
    red       = palette.red.base,     -- #e85c51
    orange    = palette.orange.base,  -- #ff8349
    yellow    = palette.yellow.base,  -- #fda47f
    blue      = palette.blue.base,    -- #5a93aa
    green     = palette.green.base,   -- #7aa4a1
    cyan      = palette.cyan.base,    -- #a1cdd8
    magenta   = palette.magenta.base, -- #ad5c7c
    pink      = palette.pink.base,    -- #cb7985
    dark_pink = "#E44675",
    grey1     = "#f8fafc",
    grey2     = "#9FA9AA",
    grey3     = "#7B8889",
    grey4     = "#586768",
    grey5     = "#465758",
    grey6     = "#3B4A4B",
    grey7     = "#364445",
    grey8     = "#324041",
    grey9     = "#2D3C3D",
    grey10    = "#293839",
    grey11    = "#253435",
    grey12    = "#213032",
    grey13    = "#0B1C1E",
    grey14    = "#1C2C2E",
    grey15    = "#18282A",
    grey16    = "#142426",
    grey17    = "#142426",
    grey18    = "#0F2022",
    grey19    = "#0B1C1E",
}

return M
