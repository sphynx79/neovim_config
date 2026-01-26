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
    local current_theme = colorscheme or vim.g.colors_name or sphynx.config.colorscheme

    local ok, palette = pcall(require, "sphynx.colors.palette." .. current_theme)
    if not ok then
        vim.notify("Couldn't load colorscheme: " .. current_theme, vim.log.levels.ERROR)
        return require("sphynx.colors.palette.nightfox").colors  -- fallback sicuro
    end

    return palette.colors
end

-- Ricarica il tema e tutti i componenti UI
colors.reload = function(theme)
    theme = theme or vim.g.colors_name

    -- Aggiorna la config
    sphynx.config.colorscheme = theme
    colors.current.theme = theme

    -- Ri-esegui il setup di nightfox per aggiornare gli highlight groups
    local nightfox_plugin = require("sphynx.plugins.nightfox")
    if nightfox_plugin.configs and nightfox_plugin.configs["nightfox"] then
        nightfox_plugin.configs["nightfox"]()
    end

    -- Applica il colorscheme
    vim.cmd("colorscheme " .. theme)

    -- Ricarica tabby per aggiornare i colori della tabline
    local tabby_plugin = require("sphynx.plugins.tabby")
    if tabby_plugin.configs and tabby_plugin.configs["tabby"] then
        tabby_plugin.configs["tabby"]()
    end

    -- Forza il redraw della tabline
    vim.cmd("redrawtabline")
end

return colors
