local utils = require("sphynx.utils")

local config = {}

function config.load()
  sphynx.config = {
    -- Auto save Buffer
    auto_save_buffer = true,
    cursorline = true,
    -- theme style to use
        -- • nightfox
        -- • onenord
    colorscheme = "nightfox",
    -- theme style variant to use
        -- • nightfox
        -- • dayfox
        -- • dawnfox
        -- • duskfox
        -- • nordfox
        -- • terafox
        -- • carbonfox
    colorscheme_variant = "nordfox",
    -- Whether the background is transparent
    -- • boolean
    transparent_background = false,
    -- lint configuration file
    -- • string
    nvim_lint_dir = utils.join_path(sphynx.path.nvim_config, "lint"),
    -- Code snippet storage directory
    -- • string
    code_snippets_directory = vim.fn.expand(vim.fn.stdpath("data") .. "/snippet"),
    ui = {
        tabufline = {
            enabled = true,
            lazyload = true,
        },
    }
  }
end

return config
