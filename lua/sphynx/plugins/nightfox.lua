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
                VirtColumn                  = { fg = palette.grey12 },
                -- Noice
                NoiceCmdlinePopup           = { fg = palette.grey3, bg = palette.bg1 },
                NoiceCmdlinePopupBorder     = { fg = palette.cyan, bg = palette.bg1 },
                NordCmdlineBorder           = { fg = palette.cyan, bg = palette.bg1 },
                NoiceCmdlinePopupTitle      = { fg = palette.cyan, bg = palette.bg1 },
                NoiceCmdlineIco             = { fg = palette.cyan, bg = palette.bg1 },
                NoicePopupmenu              = { fg = palette.grey3, bg = palette.bg1 },
                NoicePopupmenuBorder        = { fg = palette.cyan, bg = palette.bg1 },
                NoicePopupmenuSelected      = { fg = palette.grey3, bg = palette.grey12, style = 'bold' },
                NoicePopupmenuMatch         = { fg = palette.cyan, style = 'bold' },
                NoiceScrollbar              = { fg = palette.grey8, bg = palette.bg1 },
                NoiceScrollbarThumb         = { fg = palette.grey12, bg = palette.grey12 },
                NoicePopup                  = { fg = palette.grey3, bg = palette.bg1 },
                NoicePopupBorder            = { fg = palette.cyan, bg = palette.bg1 },
                -- Blink
                BlinkCmpMenu                = { fg = palette.grey3, bg = palette.bg1 },
                BlinkCmpMenuBorder          = { fg = palette.cyan, bg = palette.bg1 },
                BlinkCmpMenuSelection       = { fg = palette.grey3, bg = palette.grey12, style = 'bold' },
                BlinkCmpDoc                 = { fg = palette.grey3, bg = palette.bg1 },
                BlinkCmpDocBorder           = { fg = palette.cyan, bg = palette.bg1 },
                BlinkCmpSignatureHelp       = { fg = palette.grey3, bg = palette.bg1 },
                BlinkCmpSignatureHelpBorder = { fg = palette.cyan, bg = palette.bg1 },
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
            },
            duskfox = {
                -- TabLine
                TbiFill                     = { fg = "#e0def4", bg = "#1a182c" },
                TbBufOn                     = { fg = "#e0def4", bg = "#232136", style = "bold" },
                TbBufOff                    = { fg = "#6e6a86", bg = "#1a182c" },
                TbBufOnModified             = { fg = "#a3be8c", bg = "#232136" },
                TbBufOffModified            = { fg = "#eb6f92", bg = "#1a182c" },
                TbBufOnClose                = { fg = "#eb6f92", bg = "#232136" },
                TbBufOffClose               = { fg = "#6e6a86", bg = "#1a182c" },
                TbTabNewBtn                 = { fg = "#a3be8c", bg = "#131020" },
                TbTabOn                     = { fg = "#232136", bg = "#c4a7e7" },
                TbTabOff                    = { fg = "#e0def4", bg = "#393552" },
                TbTabCloseBtn               = { fg = "#232136", bg = "#c4a7e7" },
                TBTabTitle                  = { fg = "#e0def4", bg = "#393552" },
                TbThemeToggleBtn            = { fg = "#e0def4", bg = "#1a182c", style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#eb6f92", bg = "#1a182c", style = "bold" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#c4a7e7" },
                SmoothCursorPurple1         = { fg = "#a58fd0" },
                SmoothCursorPurple2         = { fg = "#8677b9" },
                SmoothCursorPurple3         = { fg = "#675fa2" },
                SmoothCursorPurple4         = { fg = "#48478b" },
                SmoothCursorPurple5         = { fg = "#292f74" },
                SmoothCursorPurple6         = { fg = "#1a182c" },
            },
            dayfox = {
                -- TabLine (light theme)
                TbiFill                     = { fg = "#352c24", bg = "#d3c7bb" },
                TbBufOn                     = { fg = "#352c24", bg = "#e4dcd4", style = "bold" },
                TbBufOff                    = { fg = "#a8937d", bg = "#d3c7bb" },
                TbBufOnModified             = { fg = "#618774", bg = "#e4dcd4" },
                TbBufOffModified            = { fg = "#a5222f", bg = "#d3c7bb" },
                TbBufOnClose                = { fg = "#a5222f", bg = "#e4dcd4" },
                TbBufOffClose               = { fg = "#a8937d", bg = "#d3c7bb" },
                TbTabNewBtn                 = { fg = "#618774", bg = "#c9bdb0" },
                TbTabOn                     = { fg = "#e4dcd4", bg = "#2848a9" },
                TbTabOff                    = { fg = "#352c24", bg = "#c9bdb0" },
                TbTabCloseBtn               = { fg = "#e4dcd4", bg = "#2848a9" },
                TBTabTitle                  = { fg = "#352c24", bg = "#c9bdb0" },
                TbThemeToggleBtn            = { fg = "#352c24", bg = "#d3c7bb", style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#a5222f", bg = "#d3c7bb", style = "bold" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#2848a9" },
                SmoothCursorBlue1           = { fg = "#3d5cb3" },
                SmoothCursorBlue2           = { fg = "#5270bd" },
                SmoothCursorBlue3           = { fg = "#6784c7" },
                SmoothCursorBlue4           = { fg = "#7c98d1" },
                SmoothCursorBlue5           = { fg = "#91acdb" },
                SmoothCursorBlue6           = { fg = "#a6c0e5" },
            },
            dawnfox = {
                -- TabLine (light theme, rose tinted)
                TbiFill                     = { fg = "#575279", bg = "#ebe5df" },
                TbBufOn                     = { fg = "#575279", bg = "#faf4ed", style = "bold" },
                TbBufOff                    = { fg = "#9893a5", bg = "#ebe5df" },
                TbBufOnModified             = { fg = "#618774", bg = "#faf4ed" },
                TbBufOffModified            = { fg = "#b4637a", bg = "#ebe5df" },
                TbBufOnClose                = { fg = "#b4637a", bg = "#faf4ed" },
                TbBufOffClose               = { fg = "#9893a5", bg = "#ebe5df" },
                TbTabNewBtn                 = { fg = "#618774", bg = "#e0dbd4" },
                TbTabOn                     = { fg = "#faf4ed", bg = "#907aa9" },
                TbTabOff                    = { fg = "#575279", bg = "#e0dbd4" },
                TbTabCloseBtn               = { fg = "#faf4ed", bg = "#907aa9" },
                TBTabTitle                  = { fg = "#575279", bg = "#e0dbd4" },
                TbThemeToggleBtn            = { fg = "#575279", bg = "#ebe5df", style = "bold" },
                TbCloseAllBufsBtn           = { fg = "#b4637a", bg = "#ebe5df", style = "bold" },
                -- SmoothCursor
                SmoothCursor                = { fg = "#907aa9" },
                SmoothCursorPurple1         = { fg = "#9d8ab3" },
                SmoothCursorPurple2         = { fg = "#aa9abd" },
                SmoothCursorPurple3         = { fg = "#b7aac7" },
                SmoothCursorPurple4         = { fg = "#c4bad1" },
                SmoothCursorPurple5         = { fg = "#d1cadb" },
                SmoothCursorPurple6         = { fg = "#dedae5" },
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
