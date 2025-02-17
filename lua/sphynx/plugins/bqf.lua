--[[ NOTE:
Funzionalità:
- Anteprima fluttuante
- Scorrimento intelligente
- Supporto per fzf
- Miglioramenti visivi:
- Navigazione migliorata
Keys:
Ho impostato .\sphynx\core\5-mapping.lua per chiudere e fare il toggle della quickfix
<F5>        => Toggle quickfix
<F6>        => Close quickfix
p           => Toggle preview window
zp          => Toggle preview window full size
<CR>        => Open the item under the cursor
o           => Open the item, and close quickfix window
<C-x>       => Open the item in horizontal split
<C-v>       => Open the item in vertical split
<PageUp>    => Mi sposto verso l'alto nella finestra di preview
<PageDown>  => Mi sposto verso il basso nella finestra di preview
<Fine>      => Ritorno alla poszione iniziale nella finestra di preview
<Click>     => Nella quickfix come facessi <CR>, nella preview si sposta in quella posizione del buffer
--]]



local M = {}

M.plugins = {
    ["bqf"] = {
        "kevinhwang91/nvim-bqf",
        lazy = true,
        name = "bqf",
        ft = {"qf"}
    }
}

M.setup = {

}

M.configs = {
    ["bqf"] = function()
        require('bqf').setup({
            auto_enable = true,
            auto_resize_height = true, -- highly recommended enable
            preview = {
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                winblend = 5,
                border = {'┏', '━', '┓', '┃', '┛', '━', '┗', '┃'},
                show_title = false,
                should_preview_cb = function(bufnr, qwinid)
                    local ret = true
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    local fsize = vim.fn.getfsize(bufname)
                    if fsize > 100 * 1024 then
                        -- skip file size greater than 100k
                        ret = false
                    elseif bufname:match('^fugitive://') then
                        -- skip fugitive buffer
                        ret = false
                    end
                    return ret
                end
            },
            -- make `drop` and `tab drop` to become preferred
            func_map = {
                pscrollup = '<PageUp>',
                pscrolldown = '<PageDown>',
                pscrollorig = '<End>',
            },

        })
        vim.cmd(([[
                    aug Grepper
                        au!
                        au User Grepper ++nested %s
                    aug END
                ]]):format([[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]]))


    end
}

return M

