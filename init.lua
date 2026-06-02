_G.sphynx = {}
_G.vim = vim

-- mapleader va impostato prima del caricamento dei plugin/keymap
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.loader.enable()

sphynx.path = {
    nvim_config = vim.fn.stdpath("config"),
    plugin_folder = vim.fn.stdpath("data") .. "/lazy",
    plugin_lazy_folder = vim.fn.stdpath("data") .. "/lazy" .. "/lazy.nvim",
    plugin_config_folder = vim.fn.stdpath("config") .. "/lua/sphynx/plugins/",
}

--vim.opt.rtp:prepend(sphynx.path.nvim_config)
--vim.opt.rtp:append(sphynx.path.nvim_config .. "/after")

require("sphynx.core")
