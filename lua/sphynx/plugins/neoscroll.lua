local M = {}

M.plugins = {
    ["neoscroll"] = {
        "karb94/neoscroll.nvim",
        lazy = true,
    },
}

M.setup = {
    ["neoscroll"] = function()
        M.keybindings()
    end
}

M.configs = {
    ["neoscroll"] = function()
	
		local neoscroll = require('neoscroll')
        neoscroll.setup {
            mappings = {},
			hide_cursor = true,          	-- Hide cursor while scrolling
			stop_eof = true,             	-- Stop at <EOF> when scrolling downwards
			respect_scrolloff = false,   	-- Stop scrolling when the cursor reaches the scrolloff margin of the file
            use_local_scrolloff = false,
            cursor_scrolls_alone = false, 	-- The cursor will keep on scrolling even if the window cannot scroll further
			easing = 'quadratic',           -- Default easing function
            performance_mode = true,		-- Disable "Performance Mode" on all buffers.
			duration_multiplier = 1.0,   	-- Global duration multiplier
			pre_hook = nil,              	-- Function to run before the scrolling animation starts
			post_hook = nil,             	-- Function to run after the scrolling animation ends
			ignored_events = {           	-- Events ignored while scrolling
			  'WinScrolled', 'CursorMoved'
			},
        }
		
    end
}


M.keybindings = function()
        local keymap = {
			['<localleader><Up>'] = function() require('neoscroll').scroll(-0.1, { move_cursor=false; duration = 200, easing="quintic" }) end;
			['<localleader><Up><Up>'] = function() require('neoscroll').scroll(-0.30, { move_cursor=false; duration = 590, easing="quintic" }) end;
			['<localleader><Up><Up><Up>'] = function() require('neoscroll').scroll(-0.90, { move_cursor=false; duration = 1000, easing="quintic" }) end;
			['<localleader><Down>'] = function() require('neoscroll').scroll(0.1, { move_cursor=false; duration = 200, easing="quintic" }) end;
			['<localleader><Down><Down>'] = function() require('neoscroll').scroll(0.30, { move_cursor=false; duration = 590, easing="quintic" }) end;
			['<localleader><Down><Down><Down>'] = function() require('neoscroll').scroll(0.90, { move_cursor=false; duration = 1000, easing="quintic" }) end;
		}
		
		local modes = { 'n', 'v', 'x' }
		for key, func in pairs(keymap) do
			vim.keymap.set(modes, key, func)
		end

end

return M


























