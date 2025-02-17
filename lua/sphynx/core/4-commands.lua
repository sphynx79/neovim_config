local add_cmd = vim.api.nvim_create_user_command

add_cmd("VimadeActivate", function()
  if require("sphynx.utils").plugin_is_installed("vimade") == false then
    vim.notify("You must to install Vimade", vim.log.levels.ERROR, { title = "Vimade", icon = "󰏗 ",timeout = 5000 })
    return
  end
  -- require("packer").loader "vimade"
  require("lazy").load({ plugins = { "vimade" } })
  vim.notify("Plugin Vimade loaded", vim.log.levels.INFO, { title = "Vimade", icon = "󰏗 ",timeout = 5000 })
  local ok, _  = pcall(require, "nvim-tree")

  if ok then
     vim.cmd([[NvimTreeClose]])
     vim.cmd([[VimadeEnable]])
     vim.cmd([[NvimTreeOpen]])
     return
  end
  vim.cmd([[VimadeEnable]])
end, {
    desc = "Enable Vimade",
})

add_cmd("VistaActivate", function()
    if require("sphynx.utils").plugin_is_installed("vista.vim") == false then
        vim.notify("You must to install Vista", vim.log.levels.ERROR, { title = "Vista", icon = "󰏗 ",timeout = 5000 })
        return
    end
    require("lazy").load({ plugins = { "vista.vim" } })
    vim.notify("Plugin vista loaded", vim.log.levels.INFO, { title = "Vista", icon = "󰏗 ",timeout = 5000 })
    vim.cmd([[Vista!!]])

end, {
    desc = "Enable Vista",
})

-- TODO: vede se lo posso scrivere in lua
vim.cmd([[command! -range=% MakeRubyTags :call utility#tags#make()]])
