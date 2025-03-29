local M = {}

M.plugins = {
    ["plenary.nvim"]   = { "nvim-lua/plenary.nvim" },
    ["notify"]         = { "rcarriga/nvim-notify" },
}

M.setup = {
    ["notify"] = function()
        require("notify").setup({
            stages = "fade_in_slide_out",
            timeout = 3000,
        })
    end
}

return M
