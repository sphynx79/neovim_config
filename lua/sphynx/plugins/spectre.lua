--[[ NOTE:
DESCRIZIONE:
Mi permette di cercare nel file corrente o nel progetto corrente come GREP
OSSERVAZIONI:
Per renderlo più veloce ho configurato l'utilizzo di Ag ma in realtà viene usato Ugrep
ho fatto così perchè spectre non aveva un engine con Ugrep ho aperto un issue in Github
ma non mi ha risposto
]]

local M = {}

M.plugins = {
    ["spectre"] = {
        "nvim-pack/nvim-spectre",
        lazy = true,
        module = "spectre",
    },
}

M.setup = {
    ["spectre"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["spectre"] = function()
        local ok, cmp  = pcall(require, "cmp")

        if ok then
            cmp.setup.filetype('spectre_panel', {
                completion = { autocomplete = false }
            })
        end
        require('spectre').setup({
            color_devicons = true,
            live_update = true,
            use_trouble_qf = true,
            mapping={
                    ['tab'] = {
                        map = '<Tab>',
                        cmd = "<cmd>lua require('spectre').tab()<cr>",
                        desc = 'next query'
                    },
                    ['shift-tab'] = {
                        map = '<S-Tab>',
                        cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
                        desc = 'previous query'
                    },
                    ['toggle_line'] = {
                        map = "dd",
                        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                        desc = "toggle item"
                    },
                    ['enter_file'] = {
                        map = "<cr>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                        desc = "open file"
                    },
                    ['send_to_qf'] = {
                        map = "<localleader>q",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all items to quickfix"
                    },
                    ['replace_cmd'] = {
                        map = "<localleader>c",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "input replace command"
                    },
                    ['show_option_menu'] = {
                        map = "<localleader>o",
                        cmd = "<cmd>lua require('spectre').show_options()<CR>",
                        desc = "show options"
                    },
                    ['run_current_replace'] = {
                    map = "<localleader>r",
                    cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                    desc = "replace current line"
                    },
                    ['run_replace'] = {
                        map = "<localleader>R",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "replace all"
                    },
                    ['change_view_mode'] = {
                        map = "<localleader>v",
                        cmd = "<cmd>lua require('spectre').change_view()<CR>",
                        desc = "change result view mode"
                    },
                    ['toggle_live_update']={
                    map = "tu",
                    cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
                    desc = "update when vim writes to file"
                    },
                    ['toggle_ignore_case'] = {
                    map = "ti",
                    cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                    desc = "toggle ignore case"
                    },
                    ['toggle_ignore_hidden'] = {
                    map = "th",
                    cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                    desc = "toggle search hidden"
                    },
                    ['resume_last_search'] = {
                    map = "<localleader>l",
                    cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
                    desc = "repeat last search"
                    },
                    -- you can put your mapping here it only use normal mode
                },
            find_engine = {
                -- rg is map with finder_cmd
                ['rg'] = {
                    cmd = "rg",
                    -- default args
                    args = {
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--after-context=3',
                        '--word-regexp',
                    } ,
                    options = {
                        ['ignore-case'] = {
                            value= "--ignore-case",
                            icon="[I]",
                            desc="ignore case"
                        },
                        ['hidden'] = {
                            value="--hidden",
                            desc="hidden file",
                            icon="[H]"
                        },
                        -- you can put any rg search option you want here it can toggle with
                        -- show_option function
                    }
                },
                -- ['ag'] = {
                --     cmd = "ag",
                --     args = {
                --         '--vimgrep',
                --         '-s'
                --     } ,
                --     options = {
                --         ['ignore-case'] = {
                --             value= "-i",
                --             icon="[I]",
                --             desc="ignore case"
                --         },
                --         ['hidden'] = {
                --             value="--hidden",
                --             desc="hidden file",
                --             icon="[H]"
                --         },
                --     },
                -- },
                ['ag'] = {
                    cmd = "ugrep",
                    args = {
                        '--dereference-recursive',
                        '--ignore-binary',
                        '--line-number',
                        '--column-number',
                        '--smart-case',
                        '--ungroup',
                        '--context=0',
                        '--ignore-files',
                        '--color=never',
                        '-word-regexp',
                    } ,
                    options = {
                        ['ignore-case'] = {
                            value= "-i",
                            icon="[I]",
                            desc="ignore case"
                        },
                        ['smart-case'] = {
                            value= "--smart-case",
                            icon="[J]",
                            desc="smart case"
                        },
                        ['hidden'] = {
                            value="--hidden",
                            desc="hidden file",
                            icon="[H]"
                        },
                    },
                },
            },
            default = {
                find = {
                    --pick one of item in find_engine
                    -- cmd = "ag",
                    -- options = {"smart case"}
                    cmd = "rg",
                    options = {"ignore-case"}
                },
                replace={
                    --pick one of item in replace_engine
                    cmd = "sed"
                }
            },

        })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").register({
        S = {
            name = " Search",
            s = {[[<cmd>lua require('spectre').open()<CR>]], "Search"},
            S = {[[<cmd>lua require("spectre").toggle()<CR>]], "Toggle Spectre"},
            w = {[[<cmd>lua require('spectre').open_visual({select_word=true})<CR>]], "Search word under cursor in all file"},
            f = {[[viw:lua require('spectre').open_file_search()<cr>]], "Search in current file"},
            F = {[[viw:lua require('spectre').open_file_search({select_word=true})<cr>]], "Search word under cursor in current file"},
        },
    }, mapping.opt_plugin)
    require("which-key").register({
        S = {
            name = " Search",
            v = {[[<Cmd>lua require('spectre').open_visual()<CR>]], "Visual search"},
        },
    }, mapping.opt_plugin_visual)
end

return M

