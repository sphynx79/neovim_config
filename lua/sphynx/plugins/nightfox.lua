local M = {}

M.plugins = {
    ["nightfox"] = {
        "EdenEast/nightfox.nvim",
        cond = sphynx.config.colorscheme == "nightfox",
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
    },
}

M.configs = {
    ["nightfox"] = function()
        local palette = require("sphynx.colors").get_color()

        local ok, nightfox = pcall(require, "nightfox")
        if not ok then
            return
        end

        nightfox.setup({
            options = {
                -- Compiled file's destination location
                compile_path = vim.fn.stdpath("cache") .. "/nightfox",
                compile_file_suffix = "_compiled", -- Compiled file suffix
                transparent = false,     -- Disable setting background
                terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
                dim_inactive = false,    -- Non focused panes set to alternative background
                module_default = true,   -- Default enable value for modules
                color_blind = { enable = false },
                styles = {
                    comments = "italic",
                    keywords = "bold",
                    types = "italic,bold",
                    strings = "NONE",
                    functions = "NONE",
                    variables = "NONE",
                    diagnostics = "underline",
                }
            },
            groups = {
                all = {
                    Normal                      = { fg = palette.fg, bg = palette.bg1 },
                    NormalNC                    = { bg = palette.bg1 },
                    Folded                      = { fg = palette.blue, bg = palette.grey13, style = "italic" },
                    Comment                     = { fg = palette.grey9 },
                    -- VertSplit                   = { fg = palette.grey11 },
                    WinSeparator                = { fg = palette.grey11 },
                    BufferLineIndicatorSelected = { fg = palette.cyan, bg = palette.bg },
                    BufferLineFill              = { fg = palette.fg, bg = palette.grey14 },
                    NvimTreeNormal              = { fg = palette.grey5, bg = palette.grey14 },
                    WhichKeyFloat               = { bg = palette.grey14 },
                    GitSignsAdd                 = { fg = palette.green },
                    GitSignsChange              = { fg = palette.orange },
                    GitSignsDelete              = { fg = palette.red },
                    NvimTreeFolderIcon          = { fg = palette.grey9 },
                    NvimTreeIndentMarker        = { fg = palette.grey12 },

                    -- NormalFloat                 = { bg = palette.grey14 },
                    -- FloatBorder                 = { bg = palette.grey14, fg = palette.grey14 },

                    -- TelescopePromptPrefix       = { bg = palette.grey12 },
                    -- TelescopePromptNormal       = { bg = palette.grey12 },
                    -- TelescopeResultsNormal      = { bg = palette.grey13 },
                    -- TelescopePreviewNormal      = { bg = palette.grey14 },

                    -- TelescopePromptBorder       = { bg = palette.grey12, fg = palette.grey8 },
                    -- TelescopeResultsBorder      = { bg = palette.grey13, fg = palette.grey13 },
                    -- TelescopePreviewBorder      = { bg = palette.grey14, fg = palette.grey14 },

                    -- TelescopePromptTitle        = { fg = palette.grey8 },
                    -- TelescopeResultsTitle       = { fg = palette.grey13 },
                    -- TelescopePreviewTitle       = { fg = palette.grey14 },

                    PmenuSel                    = { bg = palette.grey12 },
                    Pmenu                       = { bg = palette.grey14 },
                    PMenuThumb                  = { bg = palette.grey16 },

                    LspFloatWinNormal           = { fg = palette.fg, bg = palette.grey14 },
                    LspFloatWinBorder           = { fg = palette.grey14 },
                    -- Illuminate
                    IlluminatedWordText         = { bg = palette.grey11, style = "underline", sp=palette.grey5 },
                    IlluminatedWordRead         = { bg = palette.grey11, style = "underline", sp=palette.grey5 },
                    IlluminatedWordWrite        = { bg = palette.grey11, style = "underline", sp=palette.grey5 },
                    IlluminatedCurWord          = { bg = palette.grey16, style = "underline" },
                    -- TabLine
                    TblineFill                  = { fg = palette.fg, bg = palette.grey13 },
                    TbLineBufOn                 = { fg = palette.grey4, bg = palette.bg },
                    TbLineBufOff                = { fg = palette.grey9, bg = palette.grey13 },
                    TbLinesBufOnModified        = { fg = palette.green, bg = palette.bg },
                    TbBufLineBufOffModified     = { fg = palette.red, bg = palette.grey13 },
                    TbLineBufOnClose            = { fg = palette.red, bg = palette.bg },
                    TbLineBufOffClose           = { fg = palette.grey10, bg = palette.grey13 },
                    TblineTabNewBtn             = { fg = palette.green, bg = palette.grey19 },
                    TbLineTabOn                 = { fg = palette.bg, bg = palette.blue },
                    TbLineTabOff                = { fg = palette.fg, bg = palette.grey9 },
                    TbLineTabCloseBtn           = { fg = palette.bg, bg = palette.blue },
                    TBTabTitle                  = { fg = palette.fg, bg = palette.grey12 },
                    TbLineThemeToggleBtn        = { fg = palette.fg, bg = palette.grey19, style = "bold" },
                    TbLineCloseAllBufsBtn       = { fg = palette.red, bg = palette.bg, style = "bold" },
                    -- Scrollview
                    -- ScrollView                  = { bg = palette.grey11 },
                },
            },
            palettes = {
                all = {
                    -- bg1 = '#ebcb8b',
                },
            },
        })

        -- Set theme style:
        -- • nightfox
        -- • dayfox
        -- • dawnfox
        -- • duskfox
        -- • nordfox
        -- • terafox
        -- • carbonfox
        vim.cmd.colorscheme(sphynx.config.colorscheme_variant)
    end,
}

return M
