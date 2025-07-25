local M = {}

M.plugins = {
    ["hlslens"] = {
        "kevinhwang91/nvim-hlslens",
        lazy = true,
        name = 'hlslens',
        event = "VeryLazy",
    },
}

M.setup = {
    ["hlslens"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["hlslens"] = function()
        require("hlslens").setup {
            calm_down = true,
            nearest_only = false,
            nearest_float_when = 'never',
            override_lens = function(render, plist, nearest, idx, r_idx)
                local sfw = vim.v.searchforward == 1
                local indicator, text, chunks
                local abs_r_idx = math.abs(r_idx)
                if abs_r_idx > 1 then
                    indicator = ('%d%s'):format(abs_r_idx, sfw ~= (r_idx > 1) and '▲' or '▼')
                elseif abs_r_idx == 1 then
                    indicator = sfw ~= (r_idx == 1) and '▲' or '▼'
                else
                    indicator = ''
                end

                local lnum, col = unpack(plist[idx])
                if nearest then
                    local cnt = #plist
                    if indicator ~= '' then
                        text = ('[%s %d/%d]'):format(indicator, idx, cnt)
                    else
                        text = ('[%d/%d]'):format(idx, cnt)
                    end
                    chunks = {{' ', 'Ignore'}, {text, 'HlSearchLensNear'}}
                else
                    text = ('[%s %d]'):format(indicator, idx)
                    chunks = {{' ', 'Ignore'}, {text, 'HlSearchLens'}}
                end
                render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
            end
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        {
            mode = { "n"},
            lhs = "n",
            rhs = [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Move next occurence in serched",
        },
        {
            mode = { "n"},
            lhs = "N",
            rhs = [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            options = { silent = true },
            description = "Move previous occurence in serched",
        },
        {
            mode = { "n"},
            lhs = "*",
            rhs = [[*<Cmd>lua require('hlslens').start()<CR><Cmd>if foldlevel('.') > 0 | foldopen | endif<CR>]],
            -- rhs = [[*<Cmd>lua require('hlslens').start()<CR><Cmd>silent !foldopen<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move next",
        },
        {
            mode = { "n"},
            lhs = "#",
            rhs = [[#<Cmd>lua require('hlslens').start()<CR><Cmd>foldopen<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move previous",
        },
        {
            mode = { "n"},
            lhs = "g*",
            rhs = [[g*<Cmd>lua require('hlslens').start()<CR><Cmd>foldopen<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move next",
        },
        {
            mode = { "n"},
            lhs = "g#",
            rhs = [[g#<Cmd>lua require('hlslens').start()<CR><Cmd>foldopen<CR>]],
            options = { silent = true },
            description = "Search word under cursor and move previous",
        },
    })
end

return M

