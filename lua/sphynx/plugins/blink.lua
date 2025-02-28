local M = {}

M.plugins = {
    ["blink"] = {
        "saghen/blink.cmp",
        version = '*',
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            'onsails/lspkind.nvim'
        },
    },
}

M.configs = {
    ["blink"] = function()
        require("blink.cmp").setup({
            sources = {
                min_keyword_length = function(ctx)
                    -- doesn't apply to arguments
                    if string.find(ctx.line, ' ') == nil then return 3 end
                    return 0
                end,
                default = { "lazydev", "lsp", "path", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            -- Disable for some filetypes
            -- enabled = function()
            --     return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype)
            --     and vim.bo.buftype ~= "prompt"
            --     and vim.b.completion ~= false
            -- end,

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'normal'
            },

            completion = {
                -- 'prefix' will fuzzy match on the text before the cursor
                -- 'full' will fuzzy match on the text before _and_ after the cursor
                -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                keyword = { range = 'prefix' },

                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = {
                    create_undo_point = true,
                    auto_brackets = {
                        enabled = false,
                    },
                    
                },

                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false
                    }
                },

                menu = {
                    -- Don't automatically show the completion menu in cmdmode and search mode
                    auto_show = function(ctx)
                        return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                    end,

                    border = "single",

                    draw = {
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    local lspkind = require("lspkind")
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })
                                    end

                                    return icon .. ctx.icon_gap
                            end,

                            -- Optionally, use the highlight groups from nvim-web-devicons
                            -- You can also add the same function for `kind.highlight` if you want to
                            -- keep the highlight groups in sync with the icons.
                            highlight = function(ctx)
                                local hl = "BlinkCmpKind" .. ctx.kind
                                or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                            }
                        }
                    }
                },

                -- Show documentation when selecting a completion item
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = {
                        border = "single",
                    },
                },
                -- Display a preview of the selected item on the current line
                ghost_text = { enabled = true },
            },




            -- Experimental signature help support
            signature = {
                enabled = true,
                window = {
                    border = "single",
                },
            },

            keymap = {
                -- set to 'none' to disable the 'default' preset
                preset = 'enter',

                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },

                -- disable a keymap from the preset
                ['<C-e>'] = {},
                ['<Esc>'] = {'hide', 'fallback' },

                -- show with a list of providers
                -- ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },

                -- control whether the next command will be run when using a function
                -- ['<C-n>'] = {
                --     function(cmp)
                --     if some_condition then return end -- runs the next command
                --     return true -- doesn't run the next command
                --     end,
                --     'select_next'
                -- },
            },

            cmdline = {
                enabled = true,
                keymap = {
                    preset = 'super-tab',
                    -- OPTIONAL: sets <CR> to accept the item and run the command immediately
                    -- use `select_accept_and_enter` to accept the item or the first item if none are selected
                    ['<CR>'] = { 'accept_and_enter', 'fallback' },
                }
            },

        })
    end
}

return M

