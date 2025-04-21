--[[
===============================================================================================
Plugin: blink.cmp
===============================================================================================
Description: Un motore di autocompletamento asincrono, flessibile ed estensibile per Neovim,
             configurato per un'esperienza personalizzata.
Status: Active
Author: saghen
Repository: https://github.com/saghen/blink.cmp
Notes:
 - Autocompletamento asincrono e flessibile.
 - Configurazione granulare delle sorgenti in base al tipo di file:
    - Commenti: Solo 'buffer'.
    - Lua (con lazydev): 'lazydev', 'lsp', 'path', 'buffer'.
    - Ruby/ERB, Python: 'lsp', 'path', 'buffer', 'snippets'.
    - Markdown/Text: 'buffer', 'path'.
    - Altri: 'lsp', 'path', 'buffer'.
 - Lunghezza minima dinamica per attivazione automatica:
    - Commenti: 3 caratteri.
    - Stringhe: 2 caratteri.
    - Inizio linea senza spazi: 3 caratteri.
    - Altrimenti: 1 carattere.
 - Fuzzy matching personalizzato: Priorità ai match esatti, seguito da 'score' e 'sort_text'.
 - Disabilitazione condizionale: Escluso per tipi di file in `sphynx.config.excluded_filetypes`,
   buffer di tipo 'prompt', o se `vim.b.completion` è `false`.
 - Aspetto personalizzato:
    - Icone da `lspkind` e `nvim-web-devicons` (per i percorsi).
    - Bordi singoli per menu e documentazione.
    - Variante Nerd Font 'normal'.
 - Funzionalità aggiuntive:
    - Ghost text (preview inline) abilitato.
    - Signature help abilitato.
    - Auto-brackets disabilitato.
    - Completamento nella riga di comando abilitato (preset 'super-tab').
 - Attivazione automatica:
    - Quando si digita una parola chiave (`show_on_keyword`).
    - Quando si digita un carattere trigger (es. `.`, `:`, etc. - `show_on_trigger_character`).
 - Documentazione: Mostrata automaticamente dopo 500ms di pausa sulla selezione.

Dependencies:
  - lspkind.nvim: Per icone di tipo LSP.
  - nvim-web-devicons: Per icone specifiche dei file nei percorsi.
  - (Optional) lazydev.nvim: Per integrazione con LazyDev nei file Lua.
  - (Implicit) vim-treesitter: Utilizzato per determinare il contesto (commento, stringa)
    per `min_keyword_length`.

Keymaps:
 - <Up>      → Seleziona elemento precedente nella lista di completamento.
 - <Down>    → Seleziona elemento successivo nella lista di completamento.
 - <C-Space> → Forza l'apertura del menu di completamento se non visibile.
 - <C-e>     → Disabilitato (era 'close')
 - <Esc>     → Nascondi la lista di completamento.
 - <PageUp>  → Scrolla la documentazione verso l'alto.
 - <PageDown>→ Scrolla la documentazione verso il basso.
 - <CR>      → Accetta la selezione (configurato con `enter` preset).
 - Cmdline <CR>: Accetta la selezione e esegue il comando.

Customization Highlights:
 - Dynamic sources per filetype.
 - Dynamic minimum keyword length based on context.
 - Custom fuzzy sorting logic.
 - Tailored appearance with specific icon providers and borders.
 - Specific activation triggers and documentation delay.
 - Explicit exclusion rules.

TODO:
 - [ ] Valutare l'ottimizzazione delle performance in caso di problemi.
 - [ ] Aggiungere ulteriori personalizzazioni per tipi di file specifici se necessario.
 - [ ] Esplorare altre sorgenti di completamento utili (es. 'spell' per Markdown).
===============================================================================================
--]]

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
                    local node = vim.treesitter.get_node()
                    if node and node:type():find("comment") then return 3 end
                    if node and node:type():find("string") then return 2 end
                    return (ctx.line:find(" ") == nil) and 3 or 1
                end,
                ---@diagnostic disable-next-line: unused-local
                default = function(ctx)
                    local node = vim.treesitter.get_node()
                    local type = node and node:type() or ""

                    -- Completamento nei commenti
                    if type:find("comment") then
                        return { "buffer" }

                    -- File Lua con lazydev
                    elseif vim.bo.filetype == 'lua' and pcall(require, "lazydev.integrations.blink") then
                        return { "lazydev", "lsp", "path", "buffer" }

                    -- Ruby / Rails
                    elseif vim.bo.filetype == 'ruby' or vim.bo.filetype == 'eruby' then
                        return { "lsp", "path", "buffer", "snippets" }

                    -- Python
                    elseif vim.bo.filetype == 'python' then
                        return { "lsp", "path", "buffer", "snippets" }

                    -- Markdown / text
                    elseif vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text' then
                        return { "buffer", "path" } -- opzionalmente "spell"

                    -- Default per altri file
                    else
                        return { "lsp", "path", "buffer" }
                    end
                end,
                -- { "lazydev", "lsp", "path", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    buffer = {
                        opts = {
                        get_bufnrs = function()
                            return vim.tbl_filter(function(bufnr)
                            return vim.bo[bufnr].buftype == ''
                            end, vim.api.nvim_list_bufs())
                        end
                        }
                    },
                },
            },
            -- Disable for some filetypes
            enabled = function()
                if sphynx.config.excluded_filetypes[vim.bo.filetype] then return false end
                if vim.bo.buftype == "prompt" then return false end
                ---@diagnostic disable-next-line: undefined-field
                return vim.b.completion ~= false
            end,

            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'normal'
            },

            fuzzy = {
                sorts = {
                    -- Prioritizza i match esatti della keyword
                    function(a, b)
                        local a_exact = a.label == a.keyword
                        local b_exact = b.label == b.keyword

                        -- Se uno è un match esatto e l'altro no, quello esatto vince
                        if a_exact and not b_exact then return true end
                        if b_exact and not a_exact then return false end

                        return nil
                    end,

                    -- Sorter built-in di blink.cmp (frizbee fuzzy matcher)
                    "exact",     -- boost per match esatti
                    "score",     -- fuzzy score basato su typo, vicinanza, frequenza
                    "sort_text", -- ordinamento LSP (es. "sortText") o fallback alfabetico
                }
            },

            completion = {
                -- 'prefix' will fuzzy match on the text before the cursor
                -- 'full' will fuzzy match on the text before _and_ after the cursor
                -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                keyword = { range = 'prefix' },

                trigger = {
                    show_on_accept_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                    show_on_keyword = true,
                    show_on_trigger_character = true,
                },

                -- transform_items = function(items, ctx)
                --     local ignore = {
                --     ["if"] = true,
                --     ["else"] = true,
                --     ["then"] = true,
                --     ["end"] = true,
                --     ["do"] = true,
                --     }

                --     local filtered = {}
                --     for _, item in ipairs(items) do
                --     if not ignore[item.label] then
                --         table.insert(filtered, item)
                --     end
                --     end
                --     return filtered
                -- end,

                -- Disable auto brackets
                -- NOTE: some LSPs may add auto brackets themselves anyway
                accept = {
                    create_undo_point = true,
                    auto_brackets = {
                        enabled = true,
                    },
                },

                list = {
                    selection = {
                        preselect = function(ctx)
                            return not require('blink.cmp').snippet_active({ direction = 1 })
                        end,
                        auto_insert = false
                    }
                },

                menu = {
                    auto_show = function(ctx)
                        return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
                    end,

                    border = "single",

                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
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

                                highlight = function(ctx)
                                    local hl = "BlinkCmpKind" .. ctx.kind
                                    if not vim.fn.hlexists(hl) then
                                        hl = require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                                    end
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

                ['<PageUp>'] = { 'scroll_documentation_up', 'fallback' },
                ['<PageDown>'] = { 'scroll_documentation_down', 'fallback' },

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

