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
    }
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
  end,
}

return M
