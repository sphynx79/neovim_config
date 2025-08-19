local M = {}
local api = vim.api
local cur_buf = api.nvim_get_current_buf
local set_buf = api.nvim_set_current_buf
local get_opt = api.nvim_get_option_value
local list_tabpages = api.nvim_list_tabpages
local get_listed_bufs = require("sphynx.ui.tabufline.utils").get_listed_bufs

local function buf_index(bufnr)
  local bufs = get_listed_bufs()
  for i, value in ipairs(bufs) do
    if value == bufnr then
      return i
    end
  end
end

M.next = function()
  local bufs = get_listed_bufs()
  local curbufIndex = buf_index(cur_buf())

  if not curbufIndex then
    set_buf(vim.t.bufs[1])
    return
  end

  set_buf((curbufIndex == #bufs and bufs[1]) or bufs[curbufIndex + 1])
end

M.prev = function()
  local bufs = get_listed_bufs()
  local curbufIndex = buf_index(cur_buf())

  if not curbufIndex then
    set_buf(vim.t.bufs[1])
    return
  end

  set_buf((curbufIndex == 1 and bufs[#bufs]) or bufs[curbufIndex - 1])
end

M.close_buffer = function(bufnr)
  bufnr = bufnr or cur_buf()

  if vim.bo[bufnr].buftype == "terminal" then
    vim.cmd(vim.bo.buflisted and "set nobl | enew" or "hide")
  else
    local bufs = get_listed_bufs()
    local curBufIndex = buf_index(bufnr)
    local bufhidden = vim.bo[bufnr].bufhidden

    -- force close floating wins or nonbuflisted
    if api.nvim_win_get_config(0).zindex then
      vim.cmd "bw"
      return

      -- handle listed bufs
    elseif curBufIndex and #bufs > 1 then
      local newBufIndex = curBufIndex == #bufs and -1 or 1
      vim.cmd("b" .. bufs[curBufIndex + newBufIndex])

      -- handle unlisted
    elseif not vim.bo.buflisted then
      if #bufs > 0 then
        local tmpbufnr = bufs[1]
        local winid = vim.fn.bufwinid(tmpbufnr)
        winid = winid ~= -1 and winid or 0
        api.nvim_set_current_win(winid)
        api.nvim_set_current_buf(tmpbufnr)
      end
      vim.cmd("bw" .. bufnr)
      return
    else
      vim.cmd "enew"
    end

    if not (bufhidden == "delete") then
      vim.cmd("confirm bd" .. bufnr)
    end
  end

  vim.cmd "redrawtabline"
end

-- closes tab + all of its buffers
M.closeAllBufs = function(include_cur_buf)
  local bufs = get_listed_bufs()

  if include_cur_buf ~= nil and not include_cur_buf then
    table.remove(bufs, buf_index(cur_buf()))
  end

  for _, buf in ipairs(bufs) do
    M.close_buffer(buf)
  end
end

M.goto_buf = function(bufnr)
  local cur_win = api.nvim_get_current_win()
  local fixedbuf = api.nvim_get_option_value("winfixbuf", { win = cur_win })

  if fixedbuf then
    for _, v in ipairs(api.nvim_list_wins()) do
      local buflisted = get_opt("buflisted", { buf = api.nvim_win_get_buf(v) })
      local tmp_fixedbuf = get_opt("winfixbuf", { win = v })

      if buflisted and not tmp_fixedbuf then
        api.nvim_set_current_win(v)
        break
      end
    end
  end

  api.nvim_set_current_buf(bufnr)
end

-- Rename tab functionality
M.rename_tab = function(name)
  if not name or name == "" then
    -- Prova a ottenere il nome corrente in modo sicuro
    local current_name = ""
    local ok, tabname = pcall(vim.api.nvim_tabpage_get_var, 0, "tabname")
    if ok then
      current_name = tabname or ""
    end

    vim.ui.input({
      prompt = "Tab name: ",
      default = current_name,
    }, function(input)
      if input and input ~= "" then
        vim.api.nvim_tabpage_set_var(0, "tabname", input)
        vim.cmd "redrawtabline"
      end
    end)
  else
    vim.api.nvim_tabpage_set_var(0, "tabname", name)
    vim.cmd "redrawtabline"
  end
end

-- Get tab name (custom or default)
M.get_tab_name = function(tabnr)
  -- Converti tabnr in handle se è un numero
  local tab_handle
  if type(tabnr) == "number" then
    local tabs = list_tabpages()
    tab_handle = tabs[tabnr]
    if not tab_handle then
      return tostring(tabnr)
    end
  else
    tab_handle = tabnr
  end

  -- Usa pcall per gestire errori se la variabile non esiste
  local ok, tabname = pcall(vim.api.nvim_tabpage_get_var, tab_handle, "tabname")
  if ok and tabname then
    return tabname
  end

  -- Ritorna il numero del tab come fallback
  for i, t in ipairs(vim.api.nvim_list_tabpages()) do
    if t == tab_handle then
      return tostring(i)
    end
  end

  return tostring(tabnr)
end

return M
