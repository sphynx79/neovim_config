local M = {}

M.plugins = {
    ["vimade"] = {
        "TaDaa/vimade",
        lazy = true,
        -- cmd = {'VimadeEnable'},
    },
}

M.setup = {
    ["vimade"] = function()
        vim.g.vimade_running = false

        vim.g.vimade = {
            fadelevel = 0.6,
            usecursorhold = 1,
            enabletreesitter = 1,
            enablesigns = 1
        }

        M.keybindings()
    end,
}

M.configs = {
    ["vimade"] = function()
        require("sphynx.utils").define_augroups {
            _vimade = {
                {
                    event = "FileType",
                    opts = {
                        pattern = "nerdtree,vista,vista_kind,neoterm,dapui_scopes,dapui_breakpoints,CHADTree,NvimTree_1,NvimTree",
                        callback = function() vim.cmd [[VimadeBufDisable]] end,
                    }
                },
            }
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    require("which-key").register({
        p = {
            name = "󰏗 Plugin",
            V = { function()
                        -- require("lazy").load({ plugins = { "vimade" } })
                        vim.cmd([[VimadeActivate]])
                  end, "Vimade"},
        },
    }, mapping.opt_plugin)
end


return M

