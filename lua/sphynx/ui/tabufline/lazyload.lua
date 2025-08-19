local opts = sphynx.config.ui.tabufline
local api = vim.api
local autocmd = vim.api.nvim_create_autocmd


if opts.lazyload then
  vim.api.nvim_create_autocmd({ "BufNew", "BufNewFile", "BufRead", "TabEnter", "TermOpen" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("TabuflineLazyLoad", {}),
    callback = function()
      if #vim.fn.getbufinfo { buflisted = 1 } >= 2 or #vim.api.nvim_list_tabpages() >= 2 then
        vim.o.showtabline = 2
        vim.o.tabline = "%!v:lua.require('sphynx.ui.tabufline.modules')()"
        vim.api.nvim_del_augroup_by_name "TabuflineLazyLoad"
      end
    end,
  })
else
  vim.o.showtabline = 2
  vim.o.tabline = "%!v:lua.require('sphynx.ui.tabufline.modules')()"
end

autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Create TabRename command
vim.api.nvim_create_user_command("TabRename", function(opts)
  local tabufline = require("sphynx.ui.tabufline")
  local name = opts.args and opts.args ~= "" and opts.args or nil
  tabufline.rename_tab(name)
end, {
  nargs = "?",
  desc = "Rename current tab. Call without args to prompt for name, or provide name directly.",
  complete = function()
    -- Return current tab name as completion option
    return { vim.t.tabname or "" }
  end,
})
