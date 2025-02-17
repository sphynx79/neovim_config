local M = {}

M.plugins = {
    ["ruby_interpolation"] = {
        "p0deje/vim-ruby-interpolation",
        name = "ruby-interpolation",
        lazy = true,
        ft = {"ruby"}
    },
}

return M

