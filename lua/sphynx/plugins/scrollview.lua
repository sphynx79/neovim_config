local M = {}

M.plugins = {
    ["scrollview"] = {
        "dstein64/nvim-scrollview",
        lazy = true,
        -- commit = "14ce355d357c4b10e7dbf4ecc9c6b3533fa69f9f",
    },
}

M.setup = {
    ["scrollview"] = function()
        require("sphynx.utils.lazy_load").on_file_open "nvim-scrollview"
    end,
}

M.configs = {
    ["scrollview"] = function()
        vim.api.nvim_command([[au InsertEnter * ScrollViewDisable]])
        vim.api.nvim_command([[au InsertLeave * ScrollViewEnable]])

        require('scrollview').setup{
            excluded_filetypes = {
                'nerdtree',
                'NvimTree',
                'TelescopePrompt',
                'packer'
            },
            current_only = true,
            hide_on_intersect = true,
            winblend = 20,
            column = 1,
            zindex = 1000,
            -- scrollview_signs_on_startup = {'search'},
            -- diagnostics_severities = {vim.diagnostic.severity.ERROR},
            diagnostics_error_symbol = "",
            diagnostics_warn_symbol = " ",
            diagnostics_info_symbol = "",
            diagnostics_hint_symbol = " ",
        }
    end
}

return M

