local M = {}

M.plugins = {
    ["onenord"] = {
        "rmehri01/onenord.nvim",
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
    },
}

M.configs = {
    ["onenord"] = function()
        local palette = require("sphynx.colors.palette.onenord").colors
        local ok, onenord = pcall(require, "onenord")
        if not ok then
            return
        end

        local opts = {
            borders = true,
            fade_nc = false,
            styles = {
                comments = "italic",
                strings = "NONE",
                keywords = "NONE",
                functions = "italic",
                variables = "bold",
                diagnostics = "underline",
            },
            disable = {
                background = false,
                cursorline = false,
                eob_lines = false,
            },
            custom_highlights = {
                Normal                      = { fg = palette.fg, bg = palette.bg1 },
                NormalNC                    = { bg = palette.bg1 },
                Folded                      = { fg = palette.blue, bg = palette.grey13, style = "italic" },
                VertSplit                   = { fg = palette.grey14 },
                BufferLineIndicatorSelected = { fg = palette.cyan, bg = palette.bg },
                BufferLineFill              = { fg = palette.fg, bg = palette.grey14 },
                NvimTreeNormal              = { fg = palette.grey5, bg = palette.grey14 },
                WhichKeyFloat               = { bg = palette.grey14 },
                GitSignsAdd                 = { fg = palette.green },
                GitSignsChange              = { fg = palette.orange },
                GitSignsDelete              = { fg = palette.red },
                NvimTreeFolderIcon          = { fg = palette.grey9 },
                NvimTreeIndentMarker        = { fg = palette.grey12 },

                NormalFloat                 = { bg = palette.grey14 },
                FloatBorder                 = { bg = palette.grey14, fg = palette.grey14 },

                TelescopePromptPrefix       = { bg = palette.grey14 },
                TelescopePromptNormal       = { bg = palette.grey14 },
                TelescopeResultsNormal      = { bg = palette.grey15 },
                TelescopePreviewNormal      = { bg = palette.grey16 },

                TelescopePromptBorder       = { bg = palette.grey14, fg = palette.grey14 },
                TelescopeResultsBorder      = { bg = palette.grey15, fg = palette.grey15 },
                TelescopePreviewBorder      = { bg = palette.grey16, fg = palette.grey16 },

                TelescopePromptTitle        = { fg = palette.grey14 },
                TelescopeResultsTitle       = { fg = palette.grey15 },
                TelescopePreviewTitle       = { fg = palette.grey16 },

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
                ScrollView                  = { bg = palette.grey11 },
                -- Noice
                -- NoiceCmdlinePopupBorder     = { bg = palette.bg1, fg = palette.blue, style = "bold" },
                -- NoiceFormatTitle     = { bg = palette.bg1, fg = palette.blue, style = "bold" },
            },
        }
        onenord.setup(opts)
    end,
}

return M
