local M = {}

M.plugins = {
    ["telescope_dap"] = {
        "nvim-telescope/telescope-dap.nvim",
        name = "telescope-dap",
        lazy = true,
    },
}

M.setup = {
    ["telescope_dap"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["telescope_dap"] = function()
        local ok, telescope = pcall(require, "telescope")
        if present then
            telescope.load_extension('dap')
        end
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
	local wk = require("which-key")
	local prefix = "<leader>d"
		
    wk.add({
		{ prefix, group = "󰠭 Debug" },
		{ prefix .. "e", '<Cmd>lua require"telescope".extensions.dap.commands{}<CR>', desc = "Commands" },
		{ prefix .. "f", '<Cmd>lua require"telescope".extensions.dap.configurations{}<CR>', desc = "Configurations" },
		{ prefix .. "l", '<Cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', desc = "List breakpoints" },
		{ prefix .. "m", '<Cmd>lua require"telescope".extensions.dap.frames{}<CR>', desc = "Frames" },
		{ prefix .. "v", '<Cmd>lua require"telescope".extensions.dap.variables{}<CR>', desc = "Variables" },
    }, mapping.opt_mappping)
end

return M

