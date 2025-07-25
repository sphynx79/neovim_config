local M = {}

M.plugins = {
    ["satellite"] = {
        "lewis6991/satellite.nvim",
        lazy = true,
    },
}

M.setup = {
    ["satellite"] = function()
        require("sphynx.utils.lazy_load").on_file_open "satellite.nvim"
    end,
}

M.configs = {
    ["satellite"] = function()

        require('satellite').setup {
            current_only = true,
            winblend = 20,
            zindex = 40,
            excluded_filetypes = sphynx.config.excluded_filetypes,
            width = 6,
            handlers = {
                cursor = {
                    enable = true,
                    -- Supports any number of symbols
                    symbols = { '■' }
                    -- symbols = { '⎻', '⎼' }
                    -- Highlights:
                    -- - SatelliteCursor (default links to NonText
                },
                search = {
                    enable = true,
                    symbols = { '=' }
                    -- Highlights:
                    -- - SatelliteSearch (default links to Search)
                    -- - SatelliteSearchCurrent (default links to SearchCurrent)
                },
                diagnostic = {
                    enable = true,
                    signs = {'≡'},
                    min_severity = vim.diagnostic.severity.HINT,
                    -- Highlights:
                    -- - SatelliteDiagnosticError (default links to DiagnosticError)
                    -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
                    -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
                    -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
                },
                gitsigns = {
                    enable = false,
                    signs = { -- can only be a single character (multibyte is okay)
                        add = "│",
                        change = "│",
                        delete = "-",
                },
                -- Highlights:
                -- SatelliteGitSignsAdd (default links to GitSignsAdd)
                -- SatelliteGitSignsChange (default links to GitSignsChange)
                -- SatelliteGitSignsDelete (default links to GitSignsDelete)
                },
                marks = {
                    enable = true,
                    show_builtins = false, -- shows the builtin marks like [ ] < >
                    key = 'm'
                    -- Highlights:
                    -- SatelliteMark (default links to Normal)
                },
                quickfix = {
                    signs = { '' },
                -- Highlights:
                -- SatelliteQuickfix (default links to WarningMsg)
                }
            },
        }
        vim.cmd('highlight SatelliteCursor guifg=#88C0D0 guibg=NONE')
        vim.cmd('highlight SatelliteSearch guifg=#A3BE8C guibg=NONE')
        vim.cmd('highlight SatelliteSearchCurrent guifg=#BF616A guibg=NONE')
        vim.cmd('highlight SatelliteMark guifg=#EBCB8B guibg=NONE')
        vim.cmd('highlight SatelliteQuickfix guifg=#ECEFF4 guibg=NONE')
    end
}

return M

