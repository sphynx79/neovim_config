local M = {}
--TODO: Vedere se usare il plugin Symbols-outline, adesso disabilitato

M.plugins = {
    ["vista"] = {
        "liuchengxu/vista.vim",
        lazy = true,
        cmd = {"Vista"},
    },
}

M.setup = {
    ["vista"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["vista"] = function()
        vim.g.vista_fzf_preview = {'right:50%'}
        vim.g['vista#renderer#enable_icon'] = 1
        vim.g.vista_default_executive = 'ctags'
        vim.g.vista_icon_indent = {"╰─▸ ", "├─▸ "}
        vim.g.vista_executive_for = {
                                        ruby = 'nvim_lsp',
                                        javascrip = 'nvim_lsp',
                                    }
        vim.g.vista_ctags_cmd = { ruby = 'ctags --output-format=json --languages=ruby' }

        vim.g['vista#renderer#icons'] = {
            ["function"] = "⨍",
            ["method"] = "⨍",
        }
        vim.g.vista_echo_cursor_strategy = 'floating_win'
        vim.g['vista#renderer#default#vlnum_offset'] = 1

        vim.cmd([[autocmd FileType vista,vista_kind nnoremap <buffer> <silent> f :<c-u>call vista#finder#fzf#Run()<CR>]])

    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = {"n"},
            lhs = "<F7>",
            rhs = [[<Cmd>Vista!!<CR>]],
            options = {silent = true },
            description = "Open vista Tag-LSP list",
        },
    })
    require("which-key").register({
        p = {
            name = "󰏗 Plugin",
            v = { function()
                       vim.cmd([[VistaActivate]])
                  end, "Vista"},
        },
    }, mapping.opt_plugin)
end

return M
