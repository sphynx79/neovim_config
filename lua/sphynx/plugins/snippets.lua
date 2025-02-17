local present, ls = pcall(require, "luasnip")
if not present then
  return
end
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local ps = require("luasnip").parser.parse_snippet
local l = require('luasnip.extras').lambda
local r = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local types = require('luasnip.util.types')
local events = require('luasnip.util.events')


local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
    local buf = vim.api.nvim_create_buf(false, true)
    local buf_text = {}
    local row_selection = 0
    local row_offset = 0
    local text
    for _, node in ipairs(choiceNode.choices) do
        text = node:get_docstring()
        -- find one that is currently showing
        if node == choiceNode.active_choice then
            -- current line is starter from buffer list which is length usually
            row_selection = #buf_text
            -- finding how many lines total within a choice selection
            row_offset = #text
        end
        vim.list_extend(buf_text, text)
    end

    vim.api.nvim_buf_set_text(buf, 0,0,0,0, buf_text)
    local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

    -- adding highlight so we can see which one is been selected.
    local extmark = vim.api.nvim_buf_set_extmark(buf,current_nsid,row_selection ,0,
        {hl_group = 'incsearch',end_line = row_selection + row_offset})

    -- shows window at a beginning of choiceNode.
    local win = vim.api.nvim_open_win(buf, false, {
        relative = "win", width = w, height = h, bufpos = choiceNode.mark:pos_begin_end(), style = "minimal", border = 'rounded'})

    -- return with 3 main important so we can use them again
    return {win_id = win,extmark = extmark,buf = buf}
end

function choice_popup(choiceNode)
	-- build stack for nested choiceNodes.
	if current_win then
		vim.api.nvim_win_close(current_win.win_id, true)
                vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
	end
        local create_win = window_for_choiceNode(choiceNode)
	current_win = {
		win_id = create_win.win_id,
		prev = current_win,
		node = choiceNode,
                extmark = create_win.extmark,
                buf = create_win.buf
	}
end

function update_choice_popup(choiceNode)
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
    local create_win = window_for_choiceNode(choiceNode)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
end

function choice_popup_close()
	vim.api.nvim_win_close(current_win.win_id, true)
        vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
        -- now we are checking if we still have previous choice we were in after exit nested choice
	current_win = current_win.prev
	if current_win then
		-- reopen window further down in the stack.
                local create_win = window_for_choiceNode(current_win.node)
                current_win.win_id = create_win.win_id
                current_win.extmark = create_win.extmark
                current_win.buf = create_win.buf
	end
end

--[[ vim.cmd(
augroup choice_popup
au!
au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
au User LuasnipChoiceNodeLeave lua choice_popup_close()
au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
augroup END
)
--]]

local function copy(args)
	return args[1]
end



ls.add_snippets = {
  all = {
    s({trig="test_all", name="test all"},
      {
        t("prova_all "),
        i(1, "prova_all_guard"),
        t({"", "#prova_all "}),
        r(1),
        t({"", "", "end_prova_all "}),
        r(1),
      }
    ),
    s("data", {
      f(function()
       return "" .. os.date("%d-%m-%Y")
      end, {})
    }),
  },
  ruby = {
    s("fn", {
      -- Simple static text.
      t("//Parameters: "),
      -- function, first parameter is the function, second the Placeholders
      -- whose text it gets as input.
      f(copy, 2),
      t({ "", "function " }),
      -- Placeholder/Insert.
      i(1),
      t("("),
      -- Placeholder with initial text.
      i(2, "int foo"),
      -- Linebreak
      t({ ") {", "\t" }),
      -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
      i(0),
      t({ "", "}" }),
		}),
    ps("case",
      [[
			case ${1:test}
			when $2
			  $3
			when $4
			  $5
			else
			  $6
			end
		]]),
    s("prova", {
			-- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
			c(1, {
				t("public "),
				t("private "),
			}),
		}),
  }
}

vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-next-choice", {})


-- LuaSnipListAvailable   =>   Mostra gli Snippet attivi
