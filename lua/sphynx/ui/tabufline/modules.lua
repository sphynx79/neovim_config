local api = vim.api
local fn = vim.fn
local g = vim.g

local txt = require("sphynx.ui.tabufline.utils").txt
local btn = require("sphynx.ui.tabufline.utils").btn
local strep = string.rep
local style_buf = require("sphynx.ui.tabufline.utils").style_buf
local get_listed_bufs = require("sphynx.ui.tabufline.utils").get_listed_bufs
local cur_buf = api.nvim_get_current_buf
local opts = sphynx.config.ui.tabufline

local M = {}
g.toggle_theme_icon = "   "
g.TbTabsToggled = 0

------------------------------- btn actions functions -----------------------------------

vim.cmd [[
  function! TbGoToBuf(bufnr,b,c,d)
    call luaeval('require("sphynx.ui.tabufline").goto_buf(_A)', a:bufnr)
  endfunction]]

vim.cmd [[
  function! TbKillBuf(bufnr,b,c,d)
    call luaeval('require("sphynx.ui.tabufline").close_buffer(_A)', a:bufnr)
  endfunction]]

vim.cmd "function! TbNewTab(a,b,c,d) \n tabnew \n endfunction"
vim.cmd "function! TbGotoTab(tabnr,b,c,d) \n execute a:tabnr ..'tabnext' \n endfunction"
vim.cmd "function! TbCloseAllBufs(a,b,c,d) \n lua require('sphynx.ui.tabufline').closeAllBufs() \n endfunction"
vim.cmd "function! TbToggleTabs(a,b,c,d) \n let g:TbTabsToggled = !g:TbTabsToggled | redrawtabline \n endfunction"

---------------------------------- functions -------------------------------------------

local function getNvimTreeWidth()
  for _, win in pairs(api.nvim_tabpage_list_wins(0)) do
    if vim.bo[api.nvim_win_get_buf(win)].ft == "NvimTree" then
      return api.nvim_win_get_width(win)
    end
  end
  return 0
end

local function available_space()
  local str = ""

  for _, key in ipairs(opts.order) do
    if key ~= "buffers" then
      str = str .. M[key]()
    end
  end

  local modules = api.nvim_eval_statusline(str, { use_tabline = true })
  return vim.o.columns - modules.width
end

-- Get tab display name with truncation if needed
local function get_tab_display_name(tabnr)
  local tabufline_module = require("sphynx.ui.tabufline")
  local name = tabufline_module.get_tab_name(tabnr)

  -- Truncate long names to keep tabline readable
  local max_len = 15
  if #name > max_len then
    name = string.sub(name, 1, max_len - 2) .. ".."
  end

  return name
end

------------------------------------- modules -----------------------------------------

M.treeOffset = function()
  local w = getNvimTreeWidth()
  return w == 0 and "" or "%#NvimTreeNormal#" .. strep(" ", w) .. "%#NvimTreeWinSeparator#" .. "│"
end

M.buffers = function()
  local buffers = {}
  local has_current = false

  local bufs = get_listed_bufs()

  for i, nr in ipairs(bufs) do
    if ((#buffers + 1) * opts.bufwidth) > available_space() then
      if has_current then
        break
      end
      table.remove(buffers, 1)
    end

    has_current = cur_buf() == nr or has_current
    table.insert(buffers, style_buf(nr, i, opts.bufwidth))
  end

  return table.concat(buffers) .. txt("%=", "Fill")
end

M.tabs = function()
  local result, tabs = "", fn.tabpagenr "$"

  if tabs > 1 then
    for nr = 1, tabs, 1 do
      local tab_hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
      local tab_name = get_tab_display_name(nr)

      -- Make tab clickable for both navigation and renaming
      local tab_btn = btn(" " .. tab_name .. " ", tab_hl, "GotoTab", nr)
      result = result .. tab_btn
    end

    local new_tabtn = btn(" 󰐕 ", "TabNewBtn", "NewTab")
    local tabstoggleBtn = btn(" TABS ", "TabTitle", "ToggleTabs")
    local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")

    return g.TbTabsToggled == 1 and small_btn or new_tabtn .. tabstoggleBtn .. result
  end

  return ""
end

M.btns = function()
  local toggle_theme = btn(g.toggle_theme_icon, "ThemeToggleBtn", "Toggle_theme")
  local closeAllBufs = btn(" 󰅖 ", "CloseAllBufsBtn", "CloseAllBufs")
  return toggle_theme .. closeAllBufs
end

return function()
  local result = {}

  if opts.modules then
    for key, value in pairs(opts.modules) do
      M[key] = value
    end
  end

  for _, v in ipairs(opts.order) do
    table.insert(result, M[v]())
  end

  return table.concat(result)
end
