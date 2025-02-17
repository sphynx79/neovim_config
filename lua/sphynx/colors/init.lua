local colors = {}

-- if theme given, load given theme if given, otherwise nvchad_theme
colors.init = function(theme, reload)
    reload = reload or false
    -- if theme and vim.g.colors_name and theme ~= vim.g.colors_name then
    --     reload = true
    -- end
    -- set the global theme, used at various places like theme switcher, highlights
    if not theme then
        if vim.g.forced_theme then
            theme = vim.g.forced_theme
        elseif vim.g.colors_name then
            theme = vim.g.colors_name
        end
    end
    vim.g.colors_name = theme
end

colors.get_color = function()
    -- P(require("sphynx.colors.palette." .. vim.g.colors_name ).palette())
    if sphynx.config.colorscheme_variant then
        return require("sphynx.colors.palette." .. sphynx.config.colorscheme_variant ).colors
    end
    return require("sphynx.colors.palette." .. vim.g.colors_name ).colors
end

return colors
