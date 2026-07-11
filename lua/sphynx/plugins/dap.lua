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
 - Config Ruby di lancio: "debug current file" (ruby), rspec su file corrente / riga
   corrente / intera suite, minitest su file corrente, rails server (via bundle exec),
   tutte su porta random effimera (49152-65535)
 - Config Ruby di attach: a processo già avviato con rdbg --open, su porta fissa 38698
   oppure chiesta al volo (vim.ui.input); non lanciano nessun processo
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
Keymaps (solo durante la sessione di debug):
 - K → valuta la variabile sotto il cursore (o la selezione visual) in un popup
   (dapui.eval); premere K una seconda volta per entrare nel popup ed espandere
   le strutture con <CR>. Ripristinato all'hover LSP a fine sessione/disconnect
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
            -- Simbolo della riga corrente in arancione, preso dalla palette del tema attivo
            local palette = require("sphynx.colors").get_color()
            vim.api.nvim_set_hl(0, "DapStopped", { fg = palette.orange })

            dap.defaults.fallback.external_terminal = {
                command = "pwsh",
                args = { "-command" },
            }

            -- Override del solo debugger: lo switchbuf globale "usetab" (fix drag&drop
            -- Neovide) impedirebbe il salto nei file non ancora aperti in una finestra.
            -- "uselast" apre sempre nell'ultima finestra usata (quella dello step),
            -- senza mai cambiare tab
            dap.defaults.fallback.switchbuf = "uselast"

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

            local function restore_keymaps()
                -- Rimuove la K globale puntata su dapui.eval (pcall: potrebbe non esserci)
                pcall(api.nvim_del_keymap, "n", "K")
                for _, keymap in pairs(keymap_restore) do
                    -- Le keymap Lua (es. K dell'hover LSP) non hanno rhs ma una callback:
                    -- rhs deve essere stringa, quindi si passa "" e si ripristina la callback
                    api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs or "", {
                        silent = keymap.silent == 1,
                        noremap = keymap.noremap == 1,
                        expr = keymap.expr == 1,
                        nowait = keymap.nowait == 1,
                        callback = keymap.callback,
                        desc = keymap.desc,
                    })
                end
                keymap_restore = {}
            end

            -- Ripristino in ogni modo in cui una sessione può finire: terminazione del
            -- processo, uscita, o disconnessione manuale (attach + <leader>dx)
            dap.listeners.after["event_terminated"]["ruby"] = restore_keymaps
            dap.listeners.after["event_exited"]["ruby"] = restore_keymaps
            dap.listeners.after["disconnect"]["ruby"] = restore_keymaps

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dap_ui.open()
            end

            -- NOTE: nella finestra di repl mi permettere di fare Ctrl+r e selezionare il registro che voglio copiare
            vim.cmd([[tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi']])
            -- NOTE: dovrebbe farmi l'autocompletamento della finestra di repl ma con ruby non sta funzionando
            vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])
            vim.cmd([[set shellquote= shellxquote=]])
        end

        -- Chiede all'utente la porta a cui connettersi (config "attach existing (pick port)")
        local function pick_port()
            local port
            vim.ui.input({ prompt = "Port to connect to: " }, function(input)
                port = tonumber(input)
            end)
            return port
        end

        local function setup_ruby_adapter(dap)
            dap.adapters.ruby = function(callback, config)
                local waiting = config.waiting or 500
                local server = config.server or "127.0.0.1"
                -- Porta: fissa dalla config, altrimenti random effimera, altrimenti chiesta all'utente
                local port = config.port or (config.random_port and math.random(49152, 65535)) or pick_port()

                -- La connessione parte una volta sola: appena rdbg annuncia di essere in
                -- ascolto, oppure allo scadere del fallback `waiting`
                local session_started = false
                local function start_session()
                    if session_started then
                        return
                    end
                    session_started = true
                    callback({ type = "server", host = server, port = port })
                end

                -- Senza command la config è un puro attach: nessun processo da lanciare
                if config.command then
                    local handle
                    local stdout = vim.loop.new_pipe(false)
                    local stderr = vim.loop.new_pipe(false)
                    local pid_or_err
                    local args
                    local script
                    local rdbg

                    -- Lo script è opzionale: "run rails server" lancia solo il comando
                    if config.script then
                        if config.current_line then
                            script = config.script .. ":" .. vim.fn.line(".")
                        else
                            script = config.script
                        end
                    end

                    if config.bundle == "bundle" then
                        args = {
                            "-n",
                            "--open",
                            "--port",
                            tostring(port),
                            "-c",
                            "--",
                            "bundle",
                            "exec",
                            config.command,
                        }
                    else
                        args = { "--open", "--port", tostring(port), "-c", "--", config.command }
                    end

                    -- Opzioni del comando che precedono lo script (es. -Itest per minitest)
                    if config.command_args then
                        for _, v in ipairs(config.command_args) do
                            table.insert(args, v)
                        end
                    end

                    if script then
                        table.insert(args, script)
                    end

                    if config.args then
                        for _, v in ipairs(config.args) do
                            table.insert(args, v)
                        end
                    end

                    local opts = {
                        stdio = { nil, stdout, stderr },
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
                            local full_cmd = rdbg .. " " .. table.concat(args, " ")
                            vim.schedule(function()
                                vim.notify(
                                    "rdbg uscito con codice " .. code .. "\ncomando: " .. full_cmd,
                                    vim.log.levels.ERROR
                                )
                            end)
                        end
                    end)

                    assert(handle, "Error running rdbg: " .. tostring(pid_or_err))

                    -- rdbg scrive i messaggi "DEBUGGER:" su stderr: appena annuncia di
                    -- essere in ascolto ci si connette, senza aspettare il timeout pieno
                    local function on_output(err, chunk)
                        assert(not err, err)
                        if chunk then
                            if
                                chunk:find("wait for debugger connection", 1, true)
                                or chunk:find("Debugger can attach", 1, true)
                            then
                                vim.schedule(start_session)
                            end
                            vim.schedule(function()
                                require("dap.repl").append(chunk)
                            end)
                        end
                    end
                    stdout:read_start(on_output)
                    stderr:read_start(on_output)
                end

                -- Fallback: se il marker non viene intercettato entro `waiting` ms si
                -- tenta comunque la connessione (comportamento precedente)
                vim.defer_fn(start_session, waiting)
            end
        end

        local function setup_ruby_configuration(dap)
            -- Base comune a tutte le config; le config di lancio aggiungono porta random e attesa
            local base_config = {
                type = "ruby",
                request = "attach",
                server = "127.0.0.1",
                options = {
                    source_filetype = "ruby",
                },
                localfs = true,
            }
            -- waiting è solo il fallback massimo: di norma ci si connette appena rdbg è pronto
            local run_config = vim.tbl_extend("force", base_config, { waiting = 15000, random_port = true })
            local function extend_base_config(config)
                return vim.tbl_extend("force", base_config, config)
            end
            local function extend_run_config(config)
                return vim.tbl_extend("force", run_config, config)
            end

            dap.configurations.ruby = {
                extend_run_config({
                    name = "debug current file",
                    bundle = "",
                    command = "ruby",
                    script = "${file}",
                    args = function()
                        local argument_string = vim.fn.input("Program arguments: ")
                        if argument_string == "" then
                            return nil
                        end
                        return vim.fn.split(argument_string, " ", true)
                    end,
                }),
                -- Come sopra ma dentro Bundler: per i progetti con Gemfile le gem vengono
                -- risolte dal Gemfile.lock (evita i WARN di specs ambigue di RubyGems)
                extend_run_config({
                    name = "debug current file (bundle)",
                    bundle = "bundle",
                    command = "ruby",
                    script = "${file}",
                    args = function()
                        local argument_string = vim.fn.input("Program arguments: ")
                        if argument_string == "" then
                            return nil
                        end
                        return vim.fn.split(argument_string, " ", true)
                    end,
                }),
                extend_run_config({
                    name = "run current spec file",
                    bundle = "bundle",
                    command = "rspec",
                    script = "${file}",
                }),
                extend_run_config({
                    name = "run current spec file:current line",
                    bundle = "bundle",
                    command = "rspec",
                    script = "${file}",
                    current_line = true,
                }),
                extend_run_config({
                    name = "run rspec",
                    bundle = "bundle",
                    command = "rspec",
                    script = "./spec",
                }),
                extend_run_config({
                    name = "run minitest current file",
                    bundle = "bundle",
                    command = "ruby",
                    command_args = { "-Itest" },
                    script = "${file}",
                }),
                extend_run_config({
                    name = "run rails server",
                    bundle = "bundle",
                    command = "rails",
                    args = { "s" },
                }),
                extend_base_config({ name = "attach existing (port 38698)", port = 38698, waiting = 0 }),
                extend_base_config({ name = "attach existing (pick port)", waiting = 0 }),
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
