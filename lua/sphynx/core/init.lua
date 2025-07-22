require("sphynx.core.0-config").load()
require("sphynx.core.1-settings")
require("sphynx.core.2-autocommands")
require("sphynx.core.3-plugins")

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("sphynx.core.4-commands")
        require("sphynx.core.5-mapping")
        require("sphynx.ui")
        require("sphynx.utils.view").setup()
    end,
})


-- decommentare queste righe per fare il debug dei plugin per lua
-- e abilitare il plugin one-small-step-for-vimkind
-- vim.opt.rtp:append("C:\\Users\\en27553\\AppData\\Local\\nvim-dev-data\\lazy\\one-small-step-for-vimkind\\")
-- if init_debug then
--     require"osv".launch({port=8086, blocking=true})
-- end


-------  TESTING ---------
-- Configurazione base per il wrapping
vim.opt.wrap = true                -- Abilita il wrapping
vim.opt.linebreak = true           -- Wrap alle parole invece che ai caratteri
vim.opt.breakindent = true         -- Mantiene l'indentazione nel wrap
vim.opt.display = "lastline"       -- Mostra il più possibile dell'ultima linea
vim.opt.textwidth = 0              -- Disabilita la formattazione automatica
vim.opt.wrapmargin = 0             -- Disabilita il margine di wrapping

-- Forza l'applicazione delle impostazioni per tutti i buffer
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   pattern = "*",
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.linebreak = true
--     vim.opt_local.breakindent = true
--   end
-- })

-- -- Assicurati che il wrapping funzioni anche dopo il ridimensionamento
-- vim.api.nvim_create_autocmd("VimResized", {
--   pattern = "*",
--   callback = function()
--     vim.cmd("redraw!")
--   end
-- })

-- Crea comandi utili per gestire il wrapping
vim.api.nvim_create_user_command('ToggleWrap', function()
    vim.opt_local.wrap = not vim.opt_local.wrap:get()
    print("Wrap è " .. (vim.opt_local.wrap:get() and "attivo" or "disattivo"))
end, {})

-- Mappatura rapida per toggleare il wrap
vim.keymap.set('n', '<leader>w', ':ToggleWrap<CR>', { noremap = true, silent = true })

if (vim.fn.has("unix") == 1) then
    require("sphynx.utils.dragopen")
end
