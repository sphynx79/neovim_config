local M = {}

M.plugins = {
    ["nightfox"] = {
        "EdenEast/nightfox.nvim",
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

        local options = {
            -- Compiled file's destination location
            compile_path = vim.fn.stdpath("cache") .. "/nightfox",
            compile_file_suffix = "_compiled", -- Compiled file suffix
            transparent = false,     -- Disable setting background
            terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
            dim_inactive = true,    -- Non focused panes set to alternative background
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
        }

        local palettes = {
                all = {
                    -- bg1 = '#ebcb8b',
                },
        }

        local specs = {
            nightfox = {
                syntax = {
                    -- keyword = "magenta"
                }
            }
        }

        local groups = {
            all = {
                -- TabLine
                TbiFill                     = { fg = palette.fg, bg = palette.grey13 },
                TbBufOn                     = { fg = palette.grey4, bg = palette.bg, style = "bold" },
                TbBufOff                    = { fg = palette.grey9, bg = palette.grey13 },
                TbBufOnModified             = { fg = palette.green, bg = palette.bg },
                TbBufOffModified            = { fg = palette.red, bg = palette.grey13 },
                TbBufOnClose                = { fg = palette.red, bg = palette.bg },
                TbBufOffClose               = { fg = palette.grey10, bg = palette.grey13 },
                TbTabNewBtn                 = { fg = palette.green, bg = palette.grey19 },
                TbTabOn                     = { fg = palette.bg, bg = palette.blue },
                TbTabOff                    = { fg = palette.fg, bg = palette.grey9 },
                TbTabCloseBtn               = { fg = palette.bg, bg = palette.blue },
                TBTabTitle                  = { fg = palette.fg, bg = palette.grey12 },
                TbThemeToggleBtn            = { fg = palette.fg, bg = palette.grey13, style = "bold" },
                TbCloseAllBufsBtn           = { fg = palette.red, bg = palette.grey13, style = "bold" },
                -- IndentBlankline
                IndentBlanklineContextChar  = { fg = palette.orange },
            },
            nordfox = {
                -- Normal                      = { fg = palette.fg, bg = palette.bg1 },
                -- NormalNC                    = { bg = palette.bg1 },
                -- Folded                      = { fg = palette.blue, bg = palette.grey13, style = "italic" },
                -- Comment                     = { fg = palette.grey9 },
                -- VertSplit                   = { fg = palette.grey11 },
                -- WinSeparator                = { fg = palette.grey11 },
                -- BufferLineIndicatorSelected = { fg = palette.cyan, bg = palette.bg },
                -- BufferLineFill              = { fg = palette.fg, bg = palette.grey14 },
                -- WhichKeyFloat               = { bg = palette.grey14 },
                -- GitSignsAdd                 = { fg = palette.green },
                -- GitSignsChange              = { fg = palette.orange },
                -- GitSignsDelete              = { fg = palette.red },
                -- NvimTreeNormal              = { fg = palette.grey5, bg = palette.grey14 },
                -- NvimTreeFolderIcon          = { fg = palette.grey9 },
                -- NvimTreeIndentMarker        = { fg = palette.grey12 },

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

                -- PmenuSel                    = { bg = palette.grey12 },
                -- Pmenu                       = { bg = palette.grey14 },
                -- PMenuThumb                  = { bg = palette.grey16 },

                -- LspFloatWinNormal           = { fg = palette.fg, bg = palette.grey14 },
                -- LspFloatWinBorder           = { fg = palette.grey14 },
                -- Illuminate
                -- IlluminatedWordText         = { bg = palette.grey11, style = "underline", sp=palette.grey5 },
                -- IlluminatedWordRead         = { bg = palette.grey11, style = "underline", sp=palette.grey5 },
                -- IlluminatedWordWrite        = { bg = palette.grey11, style = "underline", sp=palette.grey5 },
                -- IlluminatedCurWord          = { bg = palette.grey16, style = "underline" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#719CD6" },
                SmoothCursorBlue1           = { fg = "#5E82B3" },
                SmoothCursorBlue2           = { fg = "#4B6990" },
                SmoothCursorBlue3           = { fg = "#39506D" },
                SmoothCursorBlue4           = { fg = "#27374A" },
                SmoothCursorBlue5           = { fg = "#151E27" },
                SmoothCursorBlue6           = { fg = "#0A0F14" },
                -- TabLine
                TbiFill                     = { fg = "#c7cdd9", bg = "#262E38" },
                TbBufOn                     = { fg = "#d9dce3", bg = "#232831", style = "bold" },
                TbBufOff                    = { fg = "#74819a", bg = "#262E38" },
                TbBufOnModified             = { fg = "#a3be8c", bg = "#232831" },
                TbBufOffModified            = { fg = "#bf616a", bg = "#262E38" },
                TbBufOnClose                = { fg = "#bf616a", bg = "#232831" },
                TbBufOffClose               = { fg = "#616d85", bg = "#262E38" },
                TbTabNewBtn                 = { fg = "#a3be8c", bg = "#020203" },
                TbTabOn                     = { fg = "#232831", bg = "#81a1c1" },
                TbTabOff                    = { fg = "#c7cdd9", bg = "#74819a" },
                TbTabCloseBtn               = { fg = "#232831", bg = "#81a1c1" },
                TBTabTitle                  = { fg = "#c7cdd9", bg = "#464f62" },
                TbThemeToggleBtn            = { fg = "#c7cdd9", bg = "#262E38" , style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#bf616a", bg = "#262E38", style = "bold" },
            },
            terafox = {
                -- TabLine
                TbiFill                     = { fg = "#eaeeee", bg = "#7aa4a1" },
                TbBufOn                     = { fg = "#d9dce3", bg = "#152528", style = "bold" },
                TbBufOnModified             = { fg = "#7aa4a1", bg = "#152528" },
                TbBufOnClose                = { fg = "#e85c51", bg = "#152528" },
                TbBufOff                    = { fg = "#586768", bg = "#0F2022" },
                TbBufOffModified            = { fg = "#586768", bg = "#0F2022" },
                TbBufOffClose               = { fg = "#586768", bg = "#0F2022" },
                TbTabNewBtn                 = { fg = "#7aa4a1", bg = "#0B1C1E" },
                TbTabOn                     = { fg = "#0f1c1e", bg = "#5a93aa" },
                TbTabOff                    = { fg = "#eaeeee", bg = "#2D3C3D" },
                TbTabCloseBtn               = { fg = "#0f1c1e", bg = "#5a93aa" },
                TBTabTitle                  = { fg = "#eaeeee", bg = "#213032" },
                TbThemeToggleBtn            = { fg = "#eaeeee", bg = "#0B1C1E", style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#e85c51", bg = "#0B1C1E", style = "bold" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#668866" },
                SmoothCursorGreen1          = { fg = "#88CC88" },
                SmoothCursorGreen2          = { fg = "#669966" },
                SmoothCursorGreen3          = { fg = "#447744" },
                SmoothCursorGreen4          = { fg = "#225522" },
                SmoothCursorGreen5          = { fg = "#113311" },
                SmoothCursorGreen6          = { fg = "#001100" },
            },
            nightfox = {
                -- TabLine
                TbiFill                     = { fg = "#d6d6d7", bg = "#101C29" },
                TbBufOn                     = { fg = "#A9ADB4", bg = "#131a24", style = "bold" },
                TbBufOff                    = { fg = "#343C48", bg = "#101C29" },
                TbBufOnModified             = { fg = "#81b29a", bg = "#131a24" },
                TbBufOffModified            = { fg = "#c94f6d", bg = "#101C29" },
                TbBufOnClose                = { fg = "#c94f6d", bg = "#131a24" },
                TbBufOffClose               = { fg = "#434A55", bg = "#101C29" },
                TbTabNewBtn                 = { fg = "#81b29a", bg = "#040507" },
                TbTabOn                     = { fg = "#131a24", bg = "#719cd6" },
                TbTabOff                    = { fg = "#d6d6d7", bg = "#343C48" },
                TbTabCloseBtn               = { fg = "#131a24", bg = "#719cd6" },
                TBTabTitle                  = { fg = "#d6d6d7", bg = "#29313C" },
                TbThemeToggleBtn            = { fg = "#d6d6d7", bg = "#101C29", style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#c94f6d", bg = "#101C29", style = "bold" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#719CD6" },
                SmoothCursorBlue1           = { fg = "#5E82B3" },
                SmoothCursorBlue2           = { fg = "#4B6990" },
                SmoothCursorBlue3           = { fg = "#39506D" },
                SmoothCursorBlue4           = { fg = "#27374A" },
                SmoothCursorBlue5           = { fg = "#151E27" },
                SmoothCursorBlue6           = { fg = "#0A0F14" },
            },
            carbonfox = {
                -- TabLine
                TbiFill                     = { fg = "#d6d6d7", bg = "#0C0C0C" },
                TbBufOn                     = { fg = "#d9dce3", bg = "#131a24", style = "bold" },
                TbBufOff                    = { fg = "#74819a", bg = "#0C0C0C" },
                TbBufOnModified             = { fg = "#81b29a", bg = "#131a24" },
                TbBufOffModified            = { fg = "#c94f6d", bg = "#0C0C0C" },
                TbBufOnClose                = { fg = "#c94f6d", bg = "#131a24" },
                TbBufOffClose               = { fg = "#719cd6", bg = "#0C0C0C" },
                TbTabNewBtn                 = { fg = "#81b29a", bg = "#020203" },
                TbTabOn                     = { fg = "#131a24", bg = "#719cd6" },
                TbTabOff                    = { fg = "#d6d6d7", bg = "#74819a" },
                TbTabCloseBtn               = { fg = "#131a24", bg = "#719cd6" },
                TBTabTitle                  = { fg = "#d6d6d7", bg = "#3a4150" },
                TbThemeToggleBtn            = { fg = "#d6d6d7", bg = "#0C0C0C", style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#c94f6d", bg = "#0C0C0C", style = "bold" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#9E7741" },
                SmoothCursorAmber1          = { fg = "#856336" },
                SmoothCursorAmber2          = { fg = "#6C502C" },
                SmoothCursorAmber3          = { fg = "#533D22" },
                SmoothCursorAmber4          = { fg = "#3A2A18" },
                SmoothCursorAmber5          = { fg = "#21170E" },
                SmoothCursorAmber6          = { fg = "#0F0B06" },
            }

        }

        nightfox.setup({
            options = options,
            palettes = palettes,
            specs = specs,
            groups = groups,

        })

        -- Set theme style:
        -- • nightfox
        -- • dayfox
        -- • dawnfox
        -- • duskfox
        -- • nordfox
        -- • terafox
        -- • carbonfox
        -- vim.cmd.colorscheme(sphynx.config.colorscheme_variant)
    end,
}

return M
