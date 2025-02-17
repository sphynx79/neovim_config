local M = {}

M.plugins = {
    ["indent_blankline"] = {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        lazy = true,
        -- event = "BufRead",
        -- after = "nvim-treesitter"
    },
}

M.setup = {
    ["indent_blankline"] = function()
        require("sphynx.utils.lazy_load").on_file_open "indent-blankline.nvim"
    end,
}

M.configs = {
    ["indent_blankline"] = function()

        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local hooks = require "ibl.hooks"

        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#79839C" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#6B7690" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#606A81" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#555E73" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#4A5264" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#3F4656" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#333946" })
            vim.api.nvim_set_hl(0, "IblScope", { fg = "#C3C7CC" })
        end)

        require("ibl").setup {
            enabled = true,
            -- exclude = {
            -- },
            indent = {
                char = "│",
                tab_char = "→",
                highlight = highlight ,
            },
            scope = {
                enabled = true,
            },
            exclude = {
                filetypes = {
                    'help',
                    'git',
                    'nerdtree',
                    'vista',
                    'Trouble',
                    'NvimTree',
                    'neoterm',
                    'qf',
                    'TelescopePrompt',
                    'markdown',
                    'packer',
                    'TelescopePrompt',
                    'lspinfo',
                    'text',
                    'markdown',
                    'snippets',
                },
                buftypes = { "terminal" },
            },

            -- show_first_indent_level = false,
            -- use_treesitter = true,
            -- show_trailing_blankline_indent = true,
            -- show_current_context = true,
            -- show_current_context_start = true,
            -- context_highlight_list = {'Warning'},
            -- indentLevel = 6,
            -- show_end_of_line = false,
            -- show_foldtext = false,
            -- context_patterns = {
            --     'class',
            --     'return',
            --     "function",
            --     'method',
            --     '^if',
            --     '^while',
            --     'jsx_element',
            --     '^for',
            --     '^object',
            --     "^table",
            --     "block",
            --     'arguments',
            --     'if_statement',
            --     'else_clause',
            --     'jsx_element',
            --     'jsx_self_closing_element',
            --     'try_statement',
            --     'catch_clause',
            --     'import_statement',
            --     'operation_type',
            -- }
        }
    end,
}

return M

