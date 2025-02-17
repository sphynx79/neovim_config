local M = {}

M.plugins = {
    ["tabular"] = {
        "godlygeek/tabular",
        lazy = true,
        cmd = {'Tabularize'},
    },
}

M.setup = {
    ["tabular"] = function()
        M.keybindings()
    end
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    -- mapping.register({
    --     {
    --         mode = { "n", "v"},
    --         lhs = "<localleader>a=",
    --         rhs = [[<Cmd>Tabularize /=<CR>]],
    --         options = {silent = true },
    --         description = "Allign with tabular plugin",
    --     },
    --     {
    --         mode = { "n", "v"},
    --         lhs = "<localleader>a:",
    --         rhs = [[<Cmd>Tabularize /:\zs<CR>]],
    --         options = {silent = true },
    --         description = "Allign with tabular plugin",
    --     },
    -- })
  require("which-key").register({
    ["a"] = {
      name = "Allign with tabular plugin",
      ["="] = {[[<Cmd>Tabularize /= <CR>]], "Allign to ="},
      [":"] = {[[<Cmd>Tabularize /:\zs <CR>]], "Allign to ;"},
    }
  }, {
    mode = { "n", "v"}, -- NORMAL mode
    prefix = "<localleader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  })
end

return M

