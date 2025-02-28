local M = {}

M.plugins = {
    ["nvim_cmp"] = {
        "hrsh7th/nvim-cmp",
        lazy = true,
        event = "BufReadPre",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            -- "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-nvim-lua"

        }
    },
}

M.setup = {
    ["nvim_cmp"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["nvim_cmp"] = function()
        local luasnip = require("luasnip")

        local has_words_before = function()
            if vim.api.nvim_get_option_value('buftype', {}) == "prompt" then
                return false
            end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local t = function(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        local get_all_buffers = function() return vim.api.nvim_list_bufs() end

        vim.opt.completeopt = "menu,menuone,noselect"
        vim.g.vsnip_snippet_dir = vim.fn.expand("$HOME" .. '/vimfiles/vsnip')


        local cmp = require("cmp")

        cmp.setup {
            experimental = {ghost_text = {hl_group = 'CommandMode'}},
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            completion = {
                keyword_length = 3,
                completeopt = "menu,menuone,noinsert"
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(_, vim_item)
                    local icons = require("sphynx.ui.icons").lspkind
                    vim_item.menu = vim_item.kind
                    vim_item.kind = icons[vim_item.kind]

                    return vim_item
                end,
            },

            window = {
            -- completion = cmp.config.window.bordered(),
                documentation = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
                },
            },

            mapping = {
                ["<C-n>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
                ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
                ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<C-e>"] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    c = function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<Tab>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end,
                }),
                ["<S-Tab>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                }),
            },
            sources = {
                { name = "nvim_lsp", priority = 100, max_item_count = 7 },
                { name = "luasnip", priority = 40, max_item_count = 3 },
                { name = "buffer",
                    option = {
                    get_bufnrs = get_all_buffers,
                    keyword_pattern = [[\k\+]] -- Include special characters in word match.
                    },
                    priority = 10,
                    max_item_count = 3,

                },
                { name = "lazydev", max_item_count = 5, group_index = 0 },
                { name = "path", priority = 80, max_item_count = 3 },
                -- { name = 'nvim_lsp_signature_help' },
                { max_item_count = 10 }
            },
            sorting = {
                comparators = {
                    cmp.config.compare.sort_text,
                    cmp.config.compare.offset,
                    -- cmp.config.compare.exact,
                    cmp.config.compare.score,
                    -- cmp.config.compare.kind,
                    -- cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
            preselect = cmp.PreselectMode.None,
        }

        -- cmp.setup.filetype('lua', {
        --     sources = cmp.config.sources({
        --         { name = "nvim_lua", max_item_count = 5 },
        --     }, {
        --         { name = 'buffer' },
        --     })
        -- })

        -- Use cmdline & path source for ':'.
        cmp.setup.cmdline(":", {
            completion = { autocomplete = false },
            sources = cmp.config.sources(
            {{ name = "path", max_item_count = 6 },},
            {{ name = "cmdline", max_item_count = 12 },},
            {{ name = "lazydev", max_item_count = 9 }}
            ),
        })

        -- lsp_document_symbols
        cmp.setup.cmdline("/", {
            completion = { autocomplete = false },
            sources = cmp.config.sources(
            {{ name = "nvim_lsp_document_symbol", max_item_count = 8, keyword_length = 1 }},
            {{ name = "buffer", max_item_count = 5, keyword_length = 2 }}
            )
        })
    end,
}

M.keybindings = function()
    local cmp = require('cmp')
    local is_enabled = true

    local toggle_cmp = function()
        is_enabled = not is_enabled
        cmp.setup({ enabled = is_enabled })
        print('CMP ' .. (is_enabled and 'ON' or 'OFF'))
    end

    vim.keymap.set('n', '<localleader>ct', toggle_cmp, { desc = 'Toggle autocompletamento' })
end


return M

