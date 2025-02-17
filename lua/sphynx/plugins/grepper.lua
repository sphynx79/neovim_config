local M = {}

M.plugins = {
    ["grepper"] = {
        "mhinz/vim-grepper",
        lazy = true,
        event = "VeryLazy",
        cmd = "Grepper",
    },
}

M.setup = {
    ["grepper"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["grepper"] = function()
        vim.g.grepper = {
            tools = {'rg', 'ag', 'pt', 'git'},
            highlight = 1,
            side = 0,
            quickfix = 1,
            prompt = 1,
            searchreg = 1,
            prompt_mapping_tool = '<localleader>g',
            prompt_mapping_side = '<localleader>s',
            rg = {
                grepprg = 'rg -H --color=never --no-heading --vimgrep --smart-case',
                -- grepformat = '%f:%l:%c:%m,%f',
                -- escape = '\\^$.*+?()[]{}|',
            },
        }
        -- Crea un gruppo di autocomandi
        local grepper_augroup = vim.api.nvim_create_augroup("GrepperGroup", { clear = true })

        -- Autocomando per GrepperSide
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "GrepperSide",
            group = grepper_augroup,
            command = [[silent execute 'keeppatterns v#'.b:grepper_side.'#>' | silent normal! ggn]]
        })
        -- Evidenziazioni
        vim.api.nvim_set_hl(0, 'Directory', {fg='#ffaf87', bg=nil})
        -- vim.api.nvim_set_hl(0, 'qfLineNr', {fg='#444444'})
        -- vim.api.nvim_set_hl(0, 'qfSeparator', {fg='#767676'})
        vim.api.nvim_set_hl(0, 'GrepperSideFile', {fg='#ffaf87'})
        vim.api.nvim_set_keymap('n', '<localleader>sa', ':Grepper -tool ag -quickfix<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<localleader>s', ':Grepper -tool rg -quickfix<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<localleader>*', ':Grepper -tool rg -cword -quickfix -noprompt<cr>', { noremap = true, silent = true })
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
	local wk = require("which-key")
	local prefix = "<leader>s"

	wk.add({
		-- Gruppo principale Grepper
		{ prefix, group = " Grepper" },
		
		-- Sottogruppo Grepper Quickfix
		{ prefix .. "s", group = " Grepper Quickfix" },
		{ prefix .. "sG", [[<Cmd>Grepper -tool git -quickfix<CR>]], desc = "Search with git" },
		{ prefix .. "sg", [[<Cmd>Grepper -tool git -quickfix<CR>]], desc = "Search word in current buffer with git" },
		{ prefix .. "sR", [[<Cmd>Grepper -tool rg -quickfix<CR>]], desc = "Search with rg" },
		{ prefix .. "sr", [[<Cmd>Grepper -tool rg -quickfix -cword -noprompt<CR>]], desc = "Search word under cursor in all file" },
		{ prefix .. "sw", [[<Cmd>Grepper -tool rg -quickfix -buffer -cword -noprompt<CR>]], desc = "Search word in current buffer" },
		{ prefix .. "sW", [[<Cmd>Grepper -tool rg -quickfix -buffer -cword -noprompt<CR>]], desc = "Search word in current open buffer" },
		
		-- Sottogruppo Grepper Side
		{ prefix .. "S", group = " Grepper Side" },
		{ prefix .. "SG", [[<Cmd>Grepper -tool git -side<CR>]], desc = "Search with git" },
		{ prefix .. "Sg", [[<Cmd>Grepper -tool git -side<CR>]], desc = "Search word in current buffer with git" },
		{ prefix .. "SR", [[<Cmd>Grepper -tool rg -side<CR>]], desc = "Search with rg" },
		{ prefix .. "Sr", [[<Cmd>Grepper -tool rg -side -cword -noprompt<CR>]], desc = "Search word under cursor in all file" },
		{ prefix .. "Sw", [[<Cmd>Grepper -tool rg -side -buffer -cword -noprompt<CR>]], desc = "Search word in current buffer" },
		{ prefix .. "SW", [[<Cmd>Grepper -tool rg -side -buffer -cword -noprompt<CR>]], desc = "Search word in current open buffer" },
	}, mapping.opt_mappping )
	
    vim.keymap.set({ 'n', 'x' }, 'gs', '<Plug>(GrepperOperator)', { remap = true })
end

return M

