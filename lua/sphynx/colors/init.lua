local colors = {}

-- Tabella per tenere traccia del tema corrente
colors.current = {
    theme = nil,
}
-- if theme given, load given theme, otherwise load config theme
colors.init = function(theme)
    -- Se theme è passato, usa quello, altrimenti usa la configurazione di default
    colors.current.theme = theme or sphynx.config.colorscheme
    vim.cmd("colorscheme " .. colors.current.theme)
end

colors.get_color = function(colorscheme)
    local current_theme = colorscheme or sphynx.config.colorscheme

    local ok, palette = pcall(require, "sphynx.colors.palette." .. current_theme)
    if not ok then
        vim.notify("Couldn't load colorscheme: " .. current_theme, vim.log.levels.ERROR)
        return require("sphynx.colors.palette.nightfox").colors  -- fallback sicuro
    end
    
    return palette.colors
end

return colors



