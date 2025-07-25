local M = {}

M.plugins = {
    ["todo-comments"] = {
        "folke/todo-comments.nvim",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["todo-comments"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["todo-comments"] = function()
        require("todo-comments").setup {
            signs = true, -- show icons in the signs column
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
            },
            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = false,
                before = "", -- "fg" or "bg" or empty
                keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
                after = "", -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
                comments_only = true, -- this applies the pattern only inside comments using `commentstring` option
            },
            -- list of named colors where we try to extract the guifg from the
            -- list of hilight groups or use the hex color if hl not found as a fallback
            colors = {
                error   = { "LspDiagnosticsDefaultHint", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info    = { "DiagnosticInfo", "#2563EB" },
                hint    = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test    = { "Identifier", "#FF00FF" },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        }
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
	
    require("which-key").register({
        x = {
            name = " Todo",
            q = {[[<Cmd>TodoQuickFix<CR>]], "todo quickfix"},
            x = {[[<Cmd>TodoTrouble<CR>]], "todo trouble"},
            t = {[[<Cmd>TodoTelescope<CR>]], "todo telescope"}
        },
    }, mapping.opt_plugin)
end


return M

