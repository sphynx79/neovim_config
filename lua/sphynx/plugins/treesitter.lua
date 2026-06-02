--[[
===============================================================================================
Plugin: nvim-treesitter (branch main)
===============================================================================================
Description: Parsing incrementale del codice per evidenziazione sintattica, indentazione e
             selezione strutturale. Usa il branch "main" (la riscrittura con nuova API):
             l'evidenziazione NON si abilita piu' da setup, ma si avvia per buffer con
             vim.treesitter.start() su evento FileType.
Status: Active
Author: nvim-treesitter
Repository: https://github.com/nvim-treesitter/nvim-treesitter
Dependencies:
 - nvim-treesitter-endwise (RRethy): chiude automaticamente i blocchi (end, endif, ...)
 - nvim-treesitter-textobjects: text object basati su treesitter (anche plugin a se')
Requisiti esterni:
 - CLI "tree-sitter" nel PATH: il branch main compila i parser con "tree-sitter build"
 - un compilatore C
Notes:
 - branch = "main", lazy = false (treesitter attivo fin dall'avvio), build = :TSUpdate
 - desired_parsers: lingue che vogliamo avere installate
 - bundled_parsers: lingue gia' incluse in Neovim, escluse dall'installazione
 - install_dir = stdpath("data")/site (coincide col default), aggiunto al runtimepath da setup
 - All'avvio install_missing_parsers() installa (async) i parser di desired non presenti
 - setup_autocmds(): su FileType avvia treesitter per il buffer (vim.treesitter.start),
   risolvendo il linguaggio con vim.treesitter.language.get_lang/add
 - register_filetype_mappings(): sh->bash, javascriptreact->javascript,
   typescriptreact->typescript
===============================================================================================
--]]

local M = {}

local desired_parsers = {
    "vim",
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
    "xml",
    "json",
    "hyprlang",
}

local bundled_parsers = {
    c = true,
    lua = true,
    markdown = true,
    markdown_inline = true,
    vim = true,
    vimdoc = true,
}

local function parser_installed(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", true) > 0
end

local function get_missing_parsers()
    local missing = {}

    for _, lang in ipairs(desired_parsers) do
        if not bundled_parsers[lang] and not parser_installed(lang) then
            table.insert(missing, lang)
        end
    end

    return missing
end

local function install_missing_parsers()
    local missing = get_missing_parsers()
    if #missing == 0 then
        return
    end

    require("nvim-treesitter").install(missing)
end

local function register_filetype_mappings()
    vim.treesitter.language.register("bash", { "sh" })
    vim.treesitter.language.register("javascript", { "javascriptreact" })
    vim.treesitter.language.register("typescript", { "typescriptreact" })
end

local function start_treesitter_for_buffer(bufnr, filetype)
    local ok, lang = pcall(vim.treesitter.language.get_lang, filetype)
    if not ok or not lang or lang == "" then
        lang = filetype
    end

    local has_parser = pcall(vim.treesitter.language.add, lang)
    if not has_parser then
        return
    end

    pcall(vim.treesitter.start, bufnr, lang)
end

local function setup_autocmds()
    local group = vim.api.nvim_create_augroup("SphynxTreesitter", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            start_treesitter_for_buffer(args.buf, args.match)
        end,
    })
end

M.plugins = {
    ["nvim-treesitter"] = {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "RRethy/nvim-treesitter-endwise",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
    },
}

M.setup = {}

M.configs = {
    ["nvim-treesitter"] = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        register_filetype_mappings()
        install_missing_parsers()
        setup_autocmds()

        -- Avvia treesitter sui buffer gia' aperti (es. file passati da riga di comando):
        -- l'autocmd FileType copre solo i buffer aperti successivamente.
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
                start_treesitter_for_buffer(buf, vim.bo[buf].filetype)
            end
        end
    end,
}

return M
