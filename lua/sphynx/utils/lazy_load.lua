local M = {}
local autocmd = vim.api.nvim_create_autocmd

M.lazy_load = function(tb)
   autocmd(tb.events, {
      pattern = "*",
      group = vim.api.nvim_create_augroup(tb.augroup_name, {}),
      callback = function()
         if tb.condition() then
            vim.api.nvim_del_augroup_by_name(tb.augroup_name)

            -- dont defer for treesitter as it will show slow highlighting
            -- This deferring only happens only when we do "nvim filename"
            if tb.plugins ~= "nvim-treesitter" then
               vim.defer_fn(function()
                  require("lazy").load({ plugins = { tb.plugins } })
                  if tb.plugin == "nvim-lspconfig" then
                    vim.cmd "silent! do FileType"
                  end
               end, 0)
            else
                require("lazy").load({ plugins = { tb.plugins } })
            end
         end
      end,
   })
end

-- load certain plugins only when there's a file opened in the buffer
-- if "nvim filename" is executed -> load the plugin after nvim gui loads
-- This gives an instant preview of nvim with the file opened
M.on_file_open = function(plugin_name)
   M.lazy_load {
      events = { "BufRead", "BufWinEnter", "BufNewFile" },
      augroup_name = "BeLazyOnFileOpen" .. plugin_name,
      plugins = plugin_name,
      condition = function()
         --recupera il nome del file corrente nel buffer
         local file = vim.fn.expand "%"
         return file ~= "NvimTree_1" and file ~= "[packer]" and file ~= ""
      end,
   }
end

M.tabufline = function()
   autocmd({ "BufNewFile", "BufRead", "TabEnter" }, {
      pattern = "*",
      group = vim.api.nvim_create_augroup("TabuflineLazyLoad", {}),
      callback = function()
         if #vim.fn.getbufinfo { buflisted = 1 } >= 2 then
            vim.opt.showtabline = 2
            vim.opt.tabline = "%!v:lua.require'sphynx.ui.tabline'.run()"
            vim.api.nvim_del_augroup_by_name "TabuflineLazyLoad"
         end
      end,
   })
end

-- lspinstaller & lspconfig cmds for lazyloading
M.lsp_cmds = {
   "LspInfo",
   "LspStart",
   "LspRestart",
   "LspStop",
   "LspInstall",
   "LspUnInstall",
   "LspUnInstallAll",
   "LspInstall",
   "LspInstallInfo",
   "LspInstallLog",
   "LspLog",
   "LspPrintInstalled",
}

M.treesitter_cmds = {
   "TSInstall",
   "TSBufEnable",
   "TSBufDisable",
   "TSEnable",
   "TSDisable",
   "TSModuleInfo",
}

return M
