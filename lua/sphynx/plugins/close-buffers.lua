local M = {}

M.plugins = {
    ["close_buffers"] = {
        "kazhala/close-buffers.nvim",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["close_buffers"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["close_buffers"] = function()
        require("close_buffers").setup({
            filetype_ignore = {},  -- Filetype to ignore when running deletions
            preserve_window_layout = { 'this' },
            -- next_buffer_cmd = function(windows)
            --    require('bufferline').cycle(1)
            --    local bufnr = vim.api.nvim_get_current_buf()

            -- for _, window in ipairs(windows) do
            --    vim.api.nvim_win_set_buf(window, bufnr)
             --   end
            -- end,
        })
    end,
}

M.keybindings = function()
		local mapping = require("sphynx.core.5-mapping")
		local wk = require("which-key")
		local prefix = "b"
		
        wk.add({
			{ prefix, group = "﬘ Buffers" },
            { prefix .. "c", [[<CMD>lua require('close_buffers').delete({type = 'this'})<CR>]], desc = "Close buffer and keep window [close-buffer]"},
            { prefix .. "x", [[<CMD>lua require('close_buffers').delete({type = 'all', force = true})<CR>]], desc = "Close all buffers [close-buffer]"},
        }, mapping.opt_mappping)
end

return M
