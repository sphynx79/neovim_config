require("sphynx.colors").init()
local config = sphynx.config
local api = vim.api

-- if tabufline_opts.enabled and tabufline_opts.lazyload then
--    require("sphynx.utils.lazy_load").tabufline()
-- elseif tabufline_opts.enabled then
--     vim.opt.showtabline = 2
--     vim.opt.tabline = "%!v:lua.require'sphynx.ui.tabline'.run()"
-- end

if config.ui.tabufline.enabled then
    require "sphynx.ui.tabufline.lazyload"
    api.nvim_create_augroup("Tabufline", { clear = true })
    api.nvim_create_autocmd("ColorScheme", {
        callback = function(args)
            local palette = require("sphynx.colors").get_color(args.match)
            api.nvim_set_hl(0, "TbiFill", { fg = palette.fg, bg = palette.grey13 })
            api.nvim_set_hl(0, "TbBufOn", { fg = palette.grey4, bg = palette.bg })
            api.nvim_set_hl(0, "TbBufOff", { fg = palette.grey9, bg = palette.grey13 })
            api.nvim_set_hl(0, "TbBufOnModified", { fg = palette.green, bg = palette.bg })
            api.nvim_set_hl(0, "TbBufOffModified", { fg = palette.red, bg = palette.grey13 })
            api.nvim_set_hl(0, "TbBufOnClose", { fg = palette.red, bg = palette.bg })
            api.nvim_set_hl(0, "TbBufOffClose", { fg = palette.grey10, bg = palette.grey13 })
            api.nvim_set_hl(0, "TbTabNewBtn", { fg = palette.green, bg = palette.grey19 })
            api.nvim_set_hl(0, "TbTabOn", { fg = palette.bg, bg = palette.blue })
            api.nvim_set_hl(0, "TbTabOff", { fg = palette.fg, bg = palette.grey9 })
            api.nvim_set_hl(0, "TbTabCloseBtn", { fg = palette.bg, bg = palette.blue })
            api.nvim_set_hl(0, "TBTabTitle", { fg = palette.fg, bg = palette.grey12 })
            api.nvim_set_hl(0, "TbThemeToggleBtn", { fg = palette.fg, bg = palette.grey13, bold = true })
            api.nvim_set_hl(0, "TbCloseAllBufsBtn", { fg = palette.red, bg = palette.grey13, bold = true })
        end,
        group = "Tabufline",
    })
end
