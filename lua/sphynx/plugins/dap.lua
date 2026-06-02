--[[
===============================================================================================
Plugin: nvim-dap
===============================================================================================
Description: Client del Debug Adapter Protocol (DAP) per Neovim: avvia/attacca debugger,
             gestisce breakpoint, step ed ispezione dello stato. Qui configurato per il
             debug di Ruby (via rdbg) e Lua (via nlua), con interfaccia grafica nvim-dap-ui.
Status: Active
Author: mfussenegger
Repository: https://github.com/mfussenegger/nvim-dap
Dependencies:
 - nvim-dap-ui (rcarriga): UI a pannelli (scopes/breakpoints/stacks/watches + repl/console)
 - nvim-nio (nvim-neotest): libreria async richiesta da nvim-dap-ui
 - sphynx.plugins.dap_utils: fornisce reload_continue() (usato da <S-F9> e <leader>dC)
Notes:
 - Caricamento lazy: il plugin si carica al primo require('dap') scatenato da una keymap
 - Adapter Ruby custom: lancia rdbg (rdbg.bat su Windows) e si connette in TCP come server
 - Tre configurazioni Ruby: "debug current file" (ruby), "run current spec file" e
   "run rspec" (rspec via bundle exec), tutte su 127.0.0.1:38698
 - Adapter nlua per il debug di Neovim Lua: RICHIEDE il plugin one-small-step-for-vimkind
   (sezione DISABLED DEBUG in 3-plugins.lua), che fornisce il server osv su :8086
 - dap-ui: layout sinistro (scopes/breakpoints/stacks/watches) + inferiore (repl/console),
   apertura automatica della UI sull'evento initialized
 - Signs personalizzati per breakpoint/condizionali/log point/stopped
 - In sessione Ruby: il tasto K viene rimappato a dapui.eval() e ripristinato a fine sessione
 - external_terminal impostato su pwsh; REPL con autocompletamento su FileType dap-repl
   e <C-R> per incollare un registro
Keymaps (function keys):
 - <F9>      → continue            - <S-F9>  → reload & continue (dap_utils)
 - <F10>     → toggle breakpoint   - <F11>   → step over
 - <F12>     → step into           - <S-F12> → step out
Keymaps (<leader>d = Debug):
 - <leader>dC → reload & continue  - <leader>dc → continue
 - <leader>di → step into          - <leader>do → step out
 - <leader>dr → repl               - <leader>ds → step over
 - <leader>du → toggle UI          - <leader>dx → disconnect & close UI
 - <leader>db → gruppo Breakpoint: dbb toggle, dbc conditional, dbl log point
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["dap"] = {
        "mfussenegger/nvim-dap",
        name = "dap",
        lazy = true,
        dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio", "theHamsta/nvim-dap-virtual-text" },
    },
}

M.setup = {
    ["dap"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["dap"] = function()
        local function settings(dap)
            local dap_ui = require("dapui")
            local api = vim.api

            dap.set_log_level("INFO")

            vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped", linehl = "", numhl = "" })

            dap.defaults.fallback.external_terminal = {
                command = "pwsh",
                args = { "-command" },
            }

            dap_ui.setup({
                icons = { expanded = "▾", collapsed = "▸" },
                mappings = {
                    -- Use a table to apply multiple mappings
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                -- Expand lines larger than the window
                -- Requires >= 0.7
                expand_lines = vim.fn.has("nvim-0.7") == 1,
                -- Layouts define sections of the screen to place windows.
                -- The position can be "left", "right", "top" or "bottom".
                -- The size specifies the height/width depending on position. It can be an Int
                -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
                -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
                -- Elements are the elements shown in the layout (in order).
                -- Layouts are opened in order so that earlier layouts take priority in window sizing.
                layouts = {
                    {
                        elements = {
                            -- You can change the order of elements in the sidebar
                            -- Elements can be strings or table with id and size keys.
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 00.25 },
                        },
                        size = 40,
                        position = "left", -- Can be "left", "right", "top", "bottom"
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 0.25, -- 25% of total lines
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen.
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                windows = { indent = 1 },
                render = {
                    max_type_length = nil, -- Can be integer or nil.
                },
            })

            local keymap_restore = {}

            dap.listeners.after["event_initialized"]["ruby"] = function()
                for _, buf in pairs(api.nvim_list_bufs()) do
                    local keymaps = api.nvim_buf_get_keymap(buf, "n")
                    for _, keymap in pairs(keymaps) do
                        if keymap.lhs == "K" then
                            table.insert(keymap_restore, keymap)
                            api.nvim_buf_del_keymap(buf, "n", "K")
                        end
                    end
                end
                api.nvim_set_keymap("n", "K", '<Cmd>lua require("dapui").eval()<CR>', { silent = true })
            end

            dap.listeners.after["event_terminated"]["ruby"] = function()
                for _, keymap in pairs(keymap_restore) do
                    api.nvim_buf_set_keymap(
                        keymap.buffer,
                        keymap.mode,
                        keymap.lhs,
                        keymap.rhs,
                        { silent = keymap.silent == 1 }
                    )
                end
                keymap_restore = {}
            end

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dap_ui.open()
            end

            -- NOTE: nella finestra di repl mi permettere di fare Ctrl+r e selezionare il registro che voglio copiare
            vim.cmd([[tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi']])
            -- NOTE: dovrebbe farmi l'autocompletamento della finestra di repl ma con ruby non sta funzionando
            vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])
            vim.cmd([[set shellquote= shellxquote=]])
        end

        local function load_module(module_name)
            local ok, module = pcall(require, module_name)
            assert(ok, string.format("dap-ruby dependency error: %s not installed", module_name))
            return module
        end

        local function setup_ruby_adapter(dap)
            dap.adapters.ruby = function(callback, config)
                local handle
                local stdout = vim.loop.new_pipe(false)
                local pid_or_err
                local waiting = config.waiting or 500
                local args
                local script
                local rdbg

                if config.current_line then
                    script = config.script .. ":" .. vim.fn.line(".")
                else
                    script = config.script
                end

                if config.bundle == "bundle" then
                    args =
                        { "-n", "--open", "--port", config.port, "-c", "--", "bundle", "exec", config.command, script }
                else
                    args = { "--open", "--port", config.port, "-c", "--", config.command, script }
                end

                if config.args then
                    for _, v in ipairs(config.args) do
                        table.insert(args, v)
                    end
                end

                local opts = {
                    stdio = { nil, stdout },
                    args = args,
                    detached = true,
                }

                if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
                    rdbg = "rdbg.bat"
                else
                    rdbg = "rdbg"
                end

                handle, pid_or_err = vim.loop.spawn(rdbg, opts, function(code)
                    handle:close()
                    if code ~= 0 then
                        print("rdbg exited with code", code)
                    end
                end)

                assert(handle, "Error running rdbg: " .. tostring(pid_or_err))

                stdout:read_start(function(err, chunk)
                    assert(not err, err)
                    if chunk then
                        vim.schedule(function()
                            require("dap.repl").append(chunk)
                        end)
                    end
                end)

                -- Wait for rdbg to start
                vim.defer_fn(function()
                    callback({ type = "server", host = config.server, port = config.port })
                end, waiting)
            end
        end

        local function setup_ruby_configuration(dap)
            dap.configurations.ruby = {
                {
                    type = "ruby",
                    name = "debug current file",
                    bundle = "",
                    request = "attach",
                    command = "ruby",
                    script = "${file}",
                    args = function()
                        local argument_string = vim.fn.input("Program arguments: ")
                        if argument_string == "" then
                            return nil
                        end
                        return vim.fn.split(argument_string, " ", true)
                    end,
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 15000,
                },
                {
                    type = "ruby",
                    name = "run current spec file",
                    bundle = "bundle",
                    request = "attach",
                    command = "rspec",
                    script = "${file}",
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 1000,
                },
                {
                    type = "ruby",
                    name = "run rspec",
                    bundle = "bundle",
                    request = "attach",
                    command = "rspec",
                    script = "./spec",
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 1000,
                },
            }
        end

        local dap = require("dap")
        settings(dap)
        setup_ruby_adapter(dap)
        setup_ruby_configuration(dap)

        -- NOTE: per usare il debug Lua (adapter nlua) serve abilitare il plugin
        -- "one-small-step-for-vimkind" (sezione DISABLED DEBUG in 3-plugins.lua):
        -- e' lui a fornire il server osv su 127.0.0.1:8086 a cui ci si connette qui.
        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    mapping.register({
        -- Session
        {
            mode = { "n" },
            lhs = "<F9>",
            rhs = [[<Cmd>lua require('dap').continue()<CR>]],
            options = { silent = true },
            description = "Dap continue",
        },
        {
            mode = { "n" },
            lhs = "<S-F9>",
            rhs = [[<Cmd>lua require('sphynx.plugins.dap_utils').reload_continue()<CR>]],
            options = { silent = true },
            description = "Dap reload continue",
        },

        -- Step
        {
            mode = { "n" },
            lhs = "<F11>",
            rhs = [[<Cmd>lua require('dap').step_over()<CR>]],
            options = { silent = true },
            description = "Dap step over",
        },
        {
            mode = { "n" },
            lhs = "<F12>",
            rhs = [[<Cmd>lua require('dap').step_into()<CR>]],
            options = { silent = true },
            description = "Dap step into",
        },
        {
            mode = { "n" },
            lhs = "<S-F12>",
            rhs = [[<Cmd>lua require('dap').step_out()<CR>]],
            options = { silent = true },
            description = "Dap step out",
        },

        -- Breakpoint
        {
            mode = { "n" },
            lhs = "<F10>",
            rhs = [[<Cmd>lua require('dap').toggle_breakpoint()<CR>]],
            options = { silent = true },
            description = "Dap toggle breakpoint",
        },
    })

    local wk = require("which-key")
    local prefix = "<leader>d"

    wk.add({
        { prefix, group = "󰠭 Debug" },
        {
            prefix .. "C",
            "<Cmd>lua require('sphynx.plugins.dap_utils').reload_continue()<CR>",
            desc = "reload and continue",
        },
        { prefix .. "c", "<Cmd>lua require('dap').continue()<CR>", desc = "continue" },
        { prefix .. "i", "<Cmd>lua require('dap').step_into()<CR>", desc = "step into" },
        { prefix .. "o", "<Cmd>lua require('dap').step_out()<CR>", desc = "step out" },
        { prefix .. "r", "<Cmd>lua require('dap').repl.open()<CR>", desc = "repl" },
        { prefix .. "s", "<Cmd>lua require('dap').step_over()<CR>", desc = "step over" },
        { prefix .. "u", "<Cmd>lua require('dapui').toggle()<CR>", desc = "toggle UI" },
        { prefix .. "x", "<Cmd>lua require('dap').disconnect() require('dapui').close()<CR>", desc = "close" },
        { prefix .. "b", group = "󰏃 Breakpoint" },
        { prefix .. "bb", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "toggle breakpoint" },
        {
            prefix .. "bc",
            "<Cmd>lua require('dap').set_breakpoint (vim.fn.input('Breakpoint condition: '))<CR>",
            desc = "conditional breakpoint",
        },
        {
            prefix .. "bl",
            "<Cmd>lua require('dap').set_breakpoint (nil, nil, vim.fn.input('Log point message: '))<CR>",
            desc = "log breakpoint",
        },
    }, mapping.opt_mappping)
end

return M
