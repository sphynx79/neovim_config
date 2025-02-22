require("sphynx.colors").init()

local tabufline_opts = sphynx.config.ui.tabufline

if tabufline_opts.enabled and tabufline_opts.lazyload then
   require("sphynx.utils.lazy_load").tabufline()
elseif tabufline_opts.enabled then
    vim.opt.showtabline = 2
    vim.opt.tabline = "%!v:lua.require'sphynx.ui.tabline'.run()"
end
