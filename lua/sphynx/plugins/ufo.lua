local M = {}

M.plugins = {
    ["ufo"] = {
        "kevinhwang91/nvim-ufo",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "kevinhwang91/promise-async",
        },
    },
}

M.setup = {
    ["ufo"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["ufo"] = function()
        require('ufo').setup({
            provider_selector = function(_, ft)
                if ft == "markdown" or ft == "rst" then
                    return { "indent" } -- prose files: simpler, faster
                end
                return { "treesitter", "indent" }
            end,

            open_fold_hl_timeout = 0, -- disable temporary highlight on open

            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local suffix = ("󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                    else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx =
                    math.max(math.min(vim.api.nvim_win_get_width(0), width - 1) - curWidth - sufWidth, 0)
                suffix = (" "):rep(rAlignAppndx) .. suffix
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end,
        })
    end,
}

M.keybindings = function()
    -- Use the preview function to display folded content
    local wk = require("which-key")

    wk.add({
        { "t", group = "󰊈 Folding" },
        { "zp", [[<Cmd>lua require('ufo').peekFoldedLinesUnderCursor()<CR>]], desc = "Peek fold [Ufo]" },
        { "zz", group = "+ Fold-Unfold all" },
        { "zz<Down>", [[<Cmd>lua require('ufo').openAllFolds()<CR>]], desc = "Open all folds [Ufo]" },
        { "zz<Up>", [[<Cmd>lua require('ufo').closeAllFolds()<CR>]], desc = "Close all folds [Ufo]" },

    })

    -- local mapping = require("sphynx.core.5-mapping")
    -- mapping.register({
    --     {
    --         mode = { "n"},
    --         lhs = "key",
    --         rhs = [[<Cmd>.....<CR>]],
    --         options = {silent = true },
    --         description = "Desc",
    --     },
    -- })
    -- require("which-key").register({
    --     x = {
    --         name = " Todo",
    --         q = {[[<Cmd>......<CR>]], "Desc"},
    --     },
    -- }, mapping.opt_plugin)
end

return M

