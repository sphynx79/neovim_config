local M = {}

local ts_filetypes = {
    "vim",
    -- "norg",
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "scss",
    "fish",
    "go",
    "graphql",
    "html",
    "javascript",
    "jsonc",
    "java",
    "latex",
    "lua",
    "nix",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "ruby",
    "rust",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vue",
    "yaml",
    "json",
    "markdown",
}

M.plugins = {
    ["nvim-treesitter"] = {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        cmd = require("sphynx.utils.lazy_load").treesitter_cmds,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
            "RRethy/nvim-treesitter-endwise",
        }
    },
}

M.setup = {
    ["nvim-treesitter"] = function()
        require("sphynx.utils.lazy_load").on_file_open "nvim-treesitter"
    end,
}

M.configs = {
    ["nvim-treesitter"] = function()
        --require 'nvim-treesitter.install'.compilers = { "zig" }
        -- require 'nvim-treesitter.install'.prefer_git = false
        require('nvim-treesitter.configs').setup {
            ensure_installed = ts_filetypes,

            highlight = {
                enable = true,              -- false will disable the whole extension
                use_languagetree = true,
                additional_vim_regex_highlighting = false,
                disable = { "vim" }
            },

            indent = {
                enable = true,
                disable = { "python" },
            },
            matchup = {
                enable = true,              -- mandatory, false will disable the whole extension
            },

        --[[ playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
            },
        }, ]]
            textsubjects = {
                enable = true,
                keymaps = {
                    ['.'] = 'textsubjects-smart',
                    [';'] = 'textsubjects-container-outer',
                }
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    scope_incremental = '<CR>',
                    node_incremental = '<TAB>',
                    node_decremental = '<S-TAB>',
                },
            },
            endwise = { enable = true },
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = 'single',
                    peek_definition_code = {
                        ["df"] = "@function.outer",
                        ["dF"] = "@class.outer",
                    },
                },
            },
        }
    end,
}



return M
