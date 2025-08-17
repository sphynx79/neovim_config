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
