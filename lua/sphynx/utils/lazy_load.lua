local M = {}
local autocmd = vim.api.nvim_create_autocmd

M.tabufline = function()
    autocmd({ "BufNewFile", "BufRead", "TabEnter" }, {
        pattern = "*",
        group = vim.api.nvim_create_augroup("TabuflineLazyLoad", {}),
        callback = function()
            if #vim.fn.getbufinfo({ buflisted = 1 }) >= 2 then
                vim.opt.showtabline = 2
                vim.opt.tabline = "%!v:lua.require'sphynx.ui.tabline'.run()"
                vim.api.nvim_del_augroup_by_name("TabuflineLazyLoad")
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
