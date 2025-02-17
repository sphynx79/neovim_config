local M = {}

M.plugins = {
    ["markdown_preview"] = {
        "iamcco/markdown-preview.nvim",
        lazy = true,
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        cmd = { "MarkdownPreview" },
    },
}

M.setup = {
    ["markdown_preview"] = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end
}

M.configs = {
    ["markdown_preview"] = function()
        vim.cmd([[
            command! -buffer MarkdownPreview call mkdp#util#open_preview_page()
            command! -buffer MarkdownPreviewStop call mkdp#util#stop_preview()
            command! -buffer MarkdownPreviewToggle call mkdp#util#toggle_preview()
        ]])
    end,
}

return M

