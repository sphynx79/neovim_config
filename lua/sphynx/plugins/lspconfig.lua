local M = {}

M.plugins = {
    ["lspconfig"] = {
        "neovim/nvim-lspconfig",
        lazy = true,
        cmd = require("sphynx.utils.lazy_load").lsp_cmds,
        ft = {
            "html",
            "typescript",
            "javascript",
            "css",
            "tex",
            "nim",
            "vim",
            "lua",
            "ruby",
        },
    },
}

M.setup = {
    ["lspconfig"] = function()
        M.keybindings()
    end
}


M.configs = {
    ["lspconfig"] = function()




        -- Custom on attach function.
        local lsp_on_attach = function(client, bufnr)
            vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

            if vim.g.lsp_handlers_enabled then
                vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'})
                vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded', min_width = 80, max_width = 180 })
            end

            -- if client.server_capabilities.inlayHintProvider then
            --     vim.notify("Inlay hint abilitato")
            --     vim.lsp.inlay_hint.enable(true, {bufnr = bufnr})
            -- end


            -- DECOMMENTARE LE SEGUENTI LINEE PER USARE RUBY-LSP
            -- _timers = {}
            -- local function setup_diagnostics(client, buffer)
            -- if require("vim.lsp.diagnostic")._enable then
            --     return
            -- end

            -- local diagnostic_handler = function()
            --     local params = vim.lsp.util.make_text_document_params(buffer)
            --     client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
            --     if err then
            --         local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
            --         vim.lsp.log.error(err_msg)
            --     end
            --     local diagnostic_items = {}
            --     if result then
            --         diagnostic_items = result.items
            --     end
            --     vim.lsp.diagnostic.on_publish_diagnostics(
            --         nil,
            --         vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
            --         { client_id = client.id }
            --     )
            --     end)
            -- end

            -- diagnostic_handler() -- to request diagnostics on buffer when first attaching

            -- vim.api.nvim_buf_attach(buffer, false, {
            --     on_lines = function()
            --     if _timers[buffer] then
            --         vim.fn.timer_stop(_timers[buffer])
            --     end
            --     _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
            --     end,
            --     on_detach = function()
            --     if _timers[buffer] then
            --         vim.fn.timer_stop(_timers[buffer])
            --     end
            --     end,
            -- })
            -- end

            -- -- adds ShowRubyDeps command to show dependencies in the quickfix list.
            -- -- add the `all` argument to show indirect dependencies as well
            -- local function add_ruby_deps_command(client, bufnr)
            --     vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps",
            --                                         function(opts)

            --         local params = vim.lsp.util.make_text_document_params()

            --         local showAll = opts.args == "all"

            --         client.request("rubyLsp/workspace/dependencies", params,
            --                         function(error, result)
            --             if error then
            --                 print("Error showing deps: " .. error)
            --                 return
            --             end

            --             local qf_list = {}
            --             for _, item in ipairs(result) do
            --                 if showAll or item.dependency then
            --                     table.insert(qf_list, {
            --                         text = string.format("%s (%s) - %s",
            --                                             item.name,
            --                                             item.version,
            --                                             item.dependency),

            --                         filename = item.path
            --                     })
            --                 end
            --             end

            --             vim.fn.setqflist(qf_list)
            --             vim.cmd('copen')
            --         end, bufnr)
            --     end, {nargs = "?", complete = function()
            --         return {"all"}
            --     end})
            -- end

            -- setup_diagnostics(client, bufnr)
            -- add_ruby_deps_command(client, bufnr)

            -- vim.notify("LSP Avviato")
        end

        -- Custom capabilities.
        local custom_capabilities = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.did_save = false
            capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
            capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
            capabilities.textDocument.completion.completionItem.preselectSupport = true
            capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
            capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
            capabilities.textDocument.completion.completionItem.snippetSupport = true;
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                },
            }

            if sphynx.config.autocomplete == "cmp" then
                local cmp_nvim_lsp_present, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
                if cmp_nvim_lsp_present then
                    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
                else
                    vim.notify("Installare cmp-nvim-lsp per autocompletamento LSP", vim.log.levels.WARN, { title = "Lsp", icon = " ",timeout = 5000 })
                end
            elseif sphynx.config.autocomplete == "blink" then
                local blink_cmp_present, blink_cmp = pcall(require, "blink.cmp")
                if blink_cmp_present then
                    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
                else
                    vim.notify("Installare blink.cmp per autocompletamento LSP", vim.log.levels.WARN, { title = "Lsp", icon = " ",timeout = 5000 })
                end
            end
            return capabilities
        end

        -- Custom handlers diagnostic.
        local handlers_diagnostic = function()
            -- Nuova API: usa vim.diagnostic.config invece di vim.lsp.with
            vim.diagnostic.config({
                signs = {
                    priority = 20,
                    signs = false,
                },
                underline = true,
                severity_sort = true,
                update_in_insert = false,
                virtual_text = { prefix = "●", source = "always" },
                -- virtual_text = {
                --   spacing = 4,
                --   prefix = '~',
                --   severity_limit = 'Warning',
                -- },
            })

            local signs = { Error = " ", Warn = " ", Hint = " ", Info = "" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end

        -- Chiamalo nel tuo setup
        handlers_diagnostic()

        local icons = require("sphynx.ui.icons")
        local sign_config_tbl = {
            text = {},
            texthl = {},
        }

        for tpe, icon in pairs(icons.diagnostics) do
            local hl = "DiagnosticSign" .. tpe
            sign_config_tbl.text[vim.diagnostic.severity[string.upper(tpe)]] = icon
            sign_config_tbl.texthl[vim.diagnostic.severity[string.upper(tpe)]] = "DiagnosticSign" .. tpe
        end

        vim.diagnostic.config({ signs = sign_config_tbl })

        local nvim_lsp = require('lspconfig')
        local util = require('lspconfig/util')
        local capabilities = custom_capabilities()


        nvim_lsp.solargraph.setup {
            capabilities = capabilities,
            cmd = {"bundle.bat", "exec", "solargraph", "stdio"},
            autostart = false;
            -- cmd = { "solargraph.bat", "stdio" },
            on_attach = lsp_on_attach,
            flags = {debounce_did_change_notify = 150, allow_incremental_sync = true},
            root_dir = util.root_pattern("Gemfile", ".git"),
            filetypes = {"ruby"},
            settings = {
                solargraph = {
                    completion  = true,
                    definitions = true,
                    references = true,
                    hover = true,
                    diagnostics = true,
                    autoformat = false,
                    formatting = false,
                    folding = false,
                    useBundler = false
                }
            },
            handlers = {
                ['textDocument/publishDiagnostics'] = handlers_diagnostic(),
            }
        }

        -- nvim_lsp.ruby_lsp.setup {
        --     capabilities = capabilities,
        --     autostart = true;
        --     on_attach = lsp_on_attach,
        --     flags = {debounce_did_change_notify = 150, allow_incremental_sync = true},
        --     handlers = {
        --         ['textDocument/publishDiagnostics'] = handlers_diagnostic(),
        --     }
        -- }

        nvim_lsp.vimls.setup {
            capabilities = capabilities,
            on_attach = lsp_on_attach,
            detached = false;
            flags = {debounce_did_change_notify = 150, allow_incremental_sync = true},
            handlers = {
                ['textDocument/publishDiagnostics'] = handlers_diagnostic(),
            }
        }

        nvim_lsp.html.setup {
            capabilities = capabilities,
            on_attach = lsp_on_attach,
            detached = false;
            flags = {debounce_did_change_notify = 150},
            cmd = {'vscode-html-language-server.cmd', '--stdio'},
            filetypes = {'eruby', 'html'},
            handlers = {
                ['textDocument/publishDiagnostics'] = handlers_diagnostic(),
            }
        }

        nvim_lsp.nimls.setup {
            capabilities = capabilities,
            detached = false;
            cmd = { "cmd", "/c", "nimlsp.cmd" },
            on_attach = lsp_on_attach,
        }

        nvim_lsp.ts_ls.setup {
            capabilities = capabilities,
            detached = false;
            on_attach = lsp_on_attach,
        }

        local ahk2_configs = {
            autostart = true,
            cmd = {
                "node",
                vim.fn.expand("C:/Users/en27553/AppData/Local/nvim-data/lsp/vscode-autohotkey2-lsp/server/dist/server.js"),
                "--stdio"
            },
            filetypes = { "ahk", "autohotkey", "ah2" },
            init_options = {
                locale = "en-us",
                InterpreterPath = "C:/APPL/AutoHotkey/v2/AutoHotkey64.exe",
                -- InterpreterPath = "C:/APPL/AutoHotkey/AutoHotkey.exe",
                -- Same as initializationOptions for Sublime Text4, convert json literal to lua dictionary literal
            },
            single_file_support = true,
            flags = { debounce_text_changes = 500 },
            capabilities = capabilities,
            on_attach = lsp_on_attach,
        }
        local configs = require "lspconfig.configs"
        configs["ahk2"] = { default_config = ahk2_configs }
        nvim_lsp.ahk2.setup({
            settings = {
                solargraph = {
                    completion  = true,
                    definitions = true,
                    references = true,
                    hover = true,
                    diagnostics = false,
                    autoformat = false,
                    formatting = false,
                    folding = true,
                }
            },
        })


        local sumneko_root_path = vim.fn.stdpath("data") .. "/lsp/lua-language-server/"
        local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"


        local luadev_conf = {
                capabilities = capabilities,
                on_attach = lsp_on_attach,
                cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
                autostart = true;
                flags = {debounce_did_change_notify = 150, allow_incremental_sync = true},
                handlers = {
                    ['textDocument/publishDiagnostics'] = handlers_diagnostic(),
                },
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                            -- Setup your lua path
                            path = vim.split(package.path, ';')
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim', 'nvim_config', 'sphynx'},
                            disable = {"lowercase-global"}
                        },
                        workspace = {
                            checkThirdParty = false,
                            -- Make the server aware of Neovim runtime files
                            library = {
                                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                            },
                            -- adjust these two values if your performance is not optimal
                            maxPreload = 2000,
                            preloadFileSize = 1000
                        },
                        telemetry = {
                            enable = false,
                        },
                    }
            }
        }
        nvim_lsp.lua_ls.setup(luadev_conf)
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "<leader>l"

    wk.add({
        { prefix, group = "󰁨 LSP" },
        { prefix .. "d", "<Cmd>lua vim.lsp.buf.definition()<CR>", desc = "go definiton" },
        { prefix .. "k", "<Cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover doc" },
    }, mapping.opt_mappping)

end

return M
