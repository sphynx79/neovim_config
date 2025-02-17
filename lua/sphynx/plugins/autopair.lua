local M = {}

M.plugins = {
    ["autopair"] = {
        "windwp/nvim-autopairs",
        lazy = true,
        event = {"InsertEnter"},
    },
}

M.configs = {
    ["autopair"] = function()
        local Rule = require('nvim-autopairs.rule')
        local npairs = require("nvim-autopairs") 

        npairs.setup {
            check_ts = true,
            disable_filetype = { "TelescopePrompt" , "vim", "nerdtree", "vista", "neoterm" },
            ts_config = {
                lua = {'string'},-- it will not add pair on that treesitter node
                javascript = {'template_string'},
                java = false,-- don't check treesitter on java
            }
        }

        local treesitter_status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
        if treesitter_status_ok then
            treesitter.setup {
                autopairs = {enable = true}
            }
            local ts_conds = require('nvim-autopairs.ts-conds')

            -- press % => %% is only inside comment or string
            npairs.add_rules({
            Rule("%", "%", "lua")
                :with_pair(ts_conds.is_ts_node({'string','comment'})),
            Rule("$", "$", "lua")
                :with_pair(ts_conds.is_not_ts_node({'function'}))
            })
        end

        local cmp_status_ok, cmp = pcall(require, "cmp")
        if cmp_status_ok then
            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { all = "(", tex = "{" })
        end
    end,
}

return  M


