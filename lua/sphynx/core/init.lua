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
