sphynx.modules = {}

local theme = function()
    if ({ nightfox = true, dayfox = true, dawnfox = true, duskfox = true, nordfox = true, terafox = true, carbonfox = true})[sphynx.config.colorscheme] then
        return "nightfox"
    else
        return "onenord"
    end
end

-- List modules
local modules = {
    --{{{ Theme
        theme(),
    --}}} Theme

    --{{{ CORE
        "core",
    --}}} CORE

    --{{{ UI
        "satellite",
        -- "scrollview",           -- OK - Barra di scorrimento
        "pretty-fold",          -- OK - Migliora il testo visualizzato nel folding
        "illuminate",           -- OK - Evidenzia altre occorrenze della parola
        "foldsigns",            -- Ok - Gestisce la visualizzazione dei segni (signs) nelle sezioni di codice piegate
        "heirline",             -- Ok - Statusline, Winbar
        "indent-blankline",     -- OK - Migliora indentazione mostrando linee visive
        "devicons",             -- OK - Aggiunge icone colorate per i file
        "smoothcursor",         -- OK - Animazione sulla barra sinistra quando mi sposto, miglioramento visivo
        "bqf",                  -- OK - Migliorare la finestra quickfix
        "rainbow-delimiters",   -- OK - Mostra le parentesi colorate
    --}}} UI

    --{{{ MAPPING
        "which-key",            -- OK - Visualizza una finestra popup con i possibili tasti e combinazioni disponibili
    --}}} MAPPING

    --{{{ LSP
        "lspconfig",            -- OK - Configurazione del Language Server Protocol (LSP)
        "lazydev",              -- OK - Migliore esperienza di sviluppo Lua in Neovim
        "floating-tag-preview", -- OK - Visualizza i tag in una floating window vicino al cursore
        "lsp-smag",             -- OK - Sostituisce l'uso dei tag file (ctags) con un sistema smart basato su LSP
        "dd",                   -- OK - Si occupa di rimandare (defer) tutti i diagnostici
        "goto-preview",         -- OK - Visualizza in finestre flottanti le anteprime dei risultati delle funzioni LSP
        "glance",               -- OK - Finestra di preview stile VSCode per esplorare definizioni, riferimenti, implementazioni e type definitions via LSP
        -- "lsp_signature",
    --}}} LSP

    --{{{ COMPLETION
        "blink",                -- OK - Autocompletamento asincrono
        "autopair",             -- OK - Inserimento automatico e la gestione di coppie di caratteri
        -- "luasnip",
        -- "cmp",
        -- "cmp-cmdline",
    --}}} COMPLETION

    --{{{ DEBUG
        "dap",
        "dap-virtual-text",
        "dap-telescope",
        -- "one-small-step-for-vimkind",
    --}}} DEBUG

    --{{{ LANGUAGE
        "ruby-interpolation",     -- OK - Aggiunge l'interpolazione delle stringhe Ruby
        "markdown-preview",       -- OK - Anteprima live nel browser per i file Markdown
        "markdown",               -- OK - Migliora supporto per file markdown
        -- "nim",
    --}}} LANGUAGE

    --{{{ FILE BROWSER AND NAVIGATION
        "nvim-tree",
        "telescope",
        "cybu",                 --Switch buffer con Tab come windows
        "nvim-window-picker",
        "maximizer",
        "workspace",
        "matchup",
        "hop",
        "marks",
        -- "window",
        -- "windowswap",
        -- "scope",
        -- "clap",
    --}}} FILE BROWSER AND NAVIGATION

    --{{{ SEARCH
        "hlslens",
        "grepper",
    --}}} SEARCH

    --{{{ EDITING
        "comment",
        "spaceless",
        "treehopper",           --mi permette con "~" di selezionare attraverso hop i nodi di treesitter
    --}}} EDITING

    -- {{{ MISC
        "treesitter",
        "noice",
        "hexokinase",
        -- --"faster",
        -- --"focus",
        "neoformat",
        "neoterm",
        "neoscroll",
        "neoclip",
        "sorround",
        -- "tabular",
        -- "todo-comments",
        "trouble",
        -- "vimade",
        -- "symbols-outline",
        -- "vista",
        "chatgpt",
        "nvim-pasta",
    -- --}}} MISC
}

-- Install Lazy if not found
local function setup_lazy()
    if not vim.uv.fs_stat(sphynx.path.plugin_lazy_folder) then
        local output = vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--single-branch",
            "https://github.com/folke/lazy.nvim.git",
            sphynx.path.plugin_lazy_folder,
        })
        if vim.api.nvim_get_vvar "shell_error" ~= 0 then
            vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" .. output)
        end
        vim.opt.cmdheight = 1
        vim.cmd "redraw"
        vim.api.nvim_echo({ { "  Please wait while plugins are installed...", "Bold" } }, true, {})
    end

    vim.opt.runtimepath:prepend(sphynx.path.plugin_lazy_folder)
end

-- Insert in global sphynx.modules all module
local function set_modules_config()
    for _, module in ipairs(modules) do
        local ok, result = xpcall(
            require,
            debug.traceback,
            string.format("sphynx.plugins.%s", module)
        )
        if ok then
            sphynx.modules[module] = result
        else
            vim.notify(result, vim.log.levels.WARN, { title = "Plugins", icon = "󰏗 ",timeout = 5000 })
        end
    end
end

-- Read from sphynx.modules plugins configurations
local function read_plugin_config()
    local plugins = {}

    set_modules_config()

    for mod_name, mod in pairs(sphynx.modules) do
        for plugin, lazy_spec in pairs(mod.plugins) do
            if
                mod.setup
                and mod.setup[plugin]
                and type(mod.setup[plugin]) == "function"
            then
                lazy_spec["init"] = mod.setup[plugin]
            end
            if
                mod.configs
                and mod.configs[plugin]
                and type(mod.configs[plugin]) == "function"
            then
                lazy_spec["config"] = mod.configs[plugin]
            end
            table.insert(plugins, lazy_spec)
        end
        -- if mod.keybindings then
        --     mod.keybindings()
        -- end
    end

    return plugins
end

-- Autostart function to initialize all plugins
Plugin_setup = (function ()
    setup_lazy()

    local present, lazy = pcall(require, "lazy")

    if not present then
        return
    end

    lazy.setup(read_plugin_config(), {
        root = sphynx.path.plugin_folder,
        lockfile = sphynx.path.nvim_config .. "/lazy-lock.json", -- lockfile generated after running update.
		-- leave nil when passing the spec as the first argument to setup()
		spec = nil, ---@type LazySpec
		local_spec = true, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
        defaults = {
            lazy = true,
        },
        concurrency = 20,
        diff = {
            cmd = "git",
        },
        git = {
            -- defaults for the `Lazy log` command
            -- log = { "-10" }, -- show the last 10 commits
            log = { "--since=7 days ago" }, -- show commits from the last 3 days
            timeout = 60, -- kill processes that take more than 1 minutes
            url_format = "https://github.com/%s.git",
            -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
            -- then set the below to false. This is should work, but is NOT supported and will
            -- increase downloads a lot.
            filter = true,
        },
		  rocks = {
			enabled = false,
		},

        performance = {
		    cache = {
				enabled = true,
			},
			reset_packpath = true,
            rtp = {
                reset = true,
                paths = {
                    sphynx.path.nvim_config,
                },
                disabled_plugins = {
                    "loaded_python3_provider",
                    "python_provider",
                    "node_provider",
                    "ruby_provider",
                    "perl_provider",
                    "2html_plugin",
                    "getscript",
                    "getscriptPlugin",
                    "gzip",
                    "tar",
                    "tarPlugin",
                    "rrhelper",
                    "vimball",
                    "vimballPlugin",
                    "zip",
                    "zipPlugin",
                    "tutor",
                    "rplugin",
                    "logiPat",
                    "netrwSettings",
                    "netrwFileHandlers",
                    "syntax",
                    "synmenu",
                    "optwin",
                    "compiler",
                    "bugreport",
                    "ftplugin",
                    "load_ftplugin",
                    "indent_on",
                    "netrwPlugin",
                    "tohtml",
                    "man",
                },
            },
        },
		-- lazy can generate helptags from the headings in markdown readme files,
		-- so :help works even for plugins that don't have vim docs.
		-- when the readme opens with :help it will be correctly displayed as markdown
		readme = {
			enabled = false,
		},
        change_detection = {
            -- automatically check for config file changes and reload the ui
            enabled = false,
            notify = false, -- get a notification when changes are found
        },
    })
end)()
