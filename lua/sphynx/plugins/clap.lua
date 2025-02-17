local M = {}

M.plugins = {
    ["clap"] = {
        "liuchengxu/vim-clap",
        lazy = true,
        build = " -> clap#installer#force_download() ",
        cmd = { "Clap" },
    },
}

M.setup = {
    ["clap"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["clap"] = function()
        vim.g['clap_layout'] = {
            relative = 'editor',
            width =  '40%',
            height = '50%',
            row = '30%',
            col = '30%',
        }

        vim.g['clap_open_preview'] = 'never'
        vim.g['clap_open_action'] = { ['ctrl-t'] = 'tab split', ['ctrl-s']= 'split', ['ctrl-v']= 'vsplit' }
        vim.g['clap_popup_border'] = 'nil'
        vim.g['clap_no_matches_msg'] = ''
        vim.g['clap_insert_mode_only'] = 1
        vim.g['clap_on_move_delay'] = 0
        vim.g['clap_maple_delay'] = 0
        vim.g['clap_popup_input_delay'] = 0
        vim.g['clap_search_box_border_symbols'] = {  ['arrow'] = {"a", "b"}, ['curve'] = {"c", "d"}, ['nil'] = {'', ''} }
        vim.g['clap_search_box_border_style'] = 'nil'
        vim.g['clap_prompt_format'] = ' %provider_id% '
        vim.g['clap_enable_icon'] = 1
        vim.g['clap_provider_grep_delay'] = 0
        -- let g:clap_search_box_border_symbols = {  'arrow': ["a", "b"], 'curve': ["c", "d"], 'nil': ['', ''] }
        local ok, cmp  = pcall(require, "cmp")

        if ok then
            cmp.setup.filetype('clap_input', {
                completion = { autocomplete = false }
            })
        end

    end
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").register({
        ["b"] = {
            name = "﬘ Buffers",
            ["b"] = {[[<Cmd>lua require('telescope.builtin').buffers(require('sphynx.plugins.telescope').no_preview())<CR>]], "Switch buffer"},
        }
    }, mapping.opt_mappping)

    require("which-key").register({
        o = {
          name = " Clap",
          f =  {[[<Cmd>Clap files<CR>]], "find files"},
        },
    }, mapping.opt_plugin)
end


return M
