local M = {}

M.plugins = {
    ["chatgpt"] = {
        "jackMort/ChatGPT.nvim",
        lazy = true,
        -- event = "VeryLazy",
        cmd = { "ChatGPTActAs", "ChatGPT", "ChatGPTRun", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim"
        }
    },
}

M.setup = {
    ["chatgpt"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["chatgpt"] = function()
        require("chatgpt").setup({
            yank_register = "+",
            max_line_length = 1000000,
            chat = {
                welcome_message = WELCOME_MESSAGE,
                loading_text = "Loading, please wait ...",
                question_sign = "", -- you can use emoji if you want e.g. 🙂
                answer_sign = "🤖", -- ﮧ
                max_line_length = 120,
                sessions_window = {
                    border = {
                        style = "rounded",
                        text = {
                            top = " Sessions ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                keymaps = {
                    close = { "<Esc>" },
                    yank_last = "<C-y>",
                    yank_last_code = "<C-k>",
                    scroll_up = "<PageUp>",
                    scroll_down = "<PageDown>",
                    toggle_settings = "<C-o>",
                    new_session = "<C-n>",
                    cycle_windows = "<Tab>",
                    select_session = "<Space>",
                    rename_session = "r",
                    delete_session = "d",
                },
            },
            popup_layout = {
                relative = "editor",
                position = "50%",
                size = {
                    height = "80%",
                    width = "80%",
                },
            },
            popup_window = {
                filetype = "chatgpt",
                border = {
                    highlight = "FloatBorder",
                    style = "rounded",
                    text = {
                        top = " ChatGPT ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
            popup_input = {
                prompt = "  ",
                border = {
                    highlight = "FloatBorder",
                    style = "rounded",
                    text = {
                        top_align = "center",
                        top = " Prompt ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
                submit = "<C-Enter>",
                submit_n = "<Enter>",
                max_visible_lines = 30,
            },
            settings_window = {
                border = {
                    style = "rounded",
                    text = {
                        top = " Settings ",
                    },
                },
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
            },
            openai_params = {
                model = "gpt-4o",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 4096,
                temperature = 0.2,
                top_p = 0.1,
                n = 1,
            },
			openai_edit_params = {
				model = "gpt-4o",
				frequency_penalty = 0,
				presence_penalty = 0,
				temperature = 0.2,
				top_p = 0.1,
				n = 1,
			},
            actions_paths = {sphynx.path.nvim_config .. "/actions.json"},
        })

    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
	local wk = require("which-key")
	local prefix = "<leader>G"

    wk.add({
          { prefix, group = " GPT" },
          { prefix .. "c", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
		  {
			mode = { "n", "v" },
				{ prefix, group = " GPT" },
				{ prefix .. "e", "<cmd>ChatGPTEditWithInstructions<CR>",          desc = "Modifica il buffer corrente con prompt" },
				{ prefix .. "C", "<cmd>ChatGPTRun complete_code<CR>", 		 		  desc = "Genera codice da testo"  },
				{ prefix .. "g", "<cmd>ChatGPTRun grammar_correction<CR>", 		  desc = "Grammar Correction" },
			    { prefix .. "t", "<cmd>ChatGPTRun translate<CR>", 				  desc = "Translate in [lang]" },
				{ prefix .. "k", "<cmd>ChatGPTRun keywords<CR>", 				  desc = "Extract the main keywords"  },
				{ prefix .. "d", "<cmd>ChatGPTRun docstring<CR>", 				  desc = "Docstring" },
				{ prefix .. "a", "<cmd>ChatGPTRun add_tests<CR>", 				  desc = "Add Tests" },
			    { prefix .. "o", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code" },
				{ prefix .. "s", "<cmd>ChatGPTRun summarize<CR>", 				  desc = "Summarize" },
				{ prefix .. "f", "<cmd>ChatGPTRun fix_bugs<CR>",  			      desc = "Fix Bugs" },
				{ prefix .. "x", "<cmd>ChatGPTRun explain_code<CR>",              desc = "Spiega il codice" },
				{ prefix .. "r", "<cmd>ChatGPTRun roxygen_edit<CR>", 			  desc = "Roxygen Edit" },
				{ prefix .. "l", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Analizza la chiarezza del codice" },
		   }
	})
	
				
	
    -- require("which-key").register({
        -- ["G"] = {
            -- name = " GPT",

            -- g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
        -- },
    -- }, mapping.opt_plugin_visual)
end

return M

