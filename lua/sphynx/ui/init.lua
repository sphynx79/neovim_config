require("sphynx.colors").init()
local config = sphynx.config

if config.ui.tabufline.enabled then
    require "sphynx.ui.tabufline.lazyload"
end
