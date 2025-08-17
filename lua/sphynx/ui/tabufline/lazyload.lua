local opts = sphynx.config.ui.tabufline
local api = vim.api
local get_opt = api.nvim_get_option_value
local cur_buf = api.nvim_get_current_buf
local autocmd = vim.api.nvim_create_autocmd

-- store listed buffers in tab
vim.t.bufs = vim.t.bufs
  or vim.tbl_filter(function(buf)
    return vim.fn.buflisted(buf) == 1
  end, vim.api.nvim_list_bufs())

-- Initialize workspace ID for current tab
vim.t.WS = vim.t.WS or vim.fn.tabpagenr()

-- Helper function to get next available workspace number
local function get_next_ws_number()
  local used = {}
  for _, tab in ipairs(api.nvim_list_tabpages()) do
    local ws = vim.t[tab].WS
    if ws then
      used[ws] = true
    end
  end

  -- Find first available number starting from 1
  local num = 1
  while used[num] do
    num = num + 1
  end
  return num
end

-- Helper function to renumber workspaces to be sequential
local function renumber_workspaces()
  local tabs = api.nvim_list_tabpages()
  local ws_map = {}

  -- Collect current workspace numbers with their tabs
  for _, tab in ipairs(tabs) do
    local ws = vim.t[tab].WS
    if ws then
      table.insert(ws_map, {tab = tab, old_ws = ws})
    end
  end

  -- Sort by tab order (not by workspace number, to maintain tab position)
  -- This ensures workspaces are numbered 1,2,3... in tab order

  -- Reassign sequential numbers
  for i, entry in ipairs(ws_map) do
    local old_ws = entry.old_ws
    local new_ws = i

    -- Update tab workspace number
    vim.t[entry.tab].WS = new_ws

    -- Update all buffers that belonged to the old workspace
    if old_ws ~= new_ws then
      for _, buf in ipairs(api.nvim_list_bufs()) do
        if get_buf_workspace(buf) == old_ws then
          set_buf_workspace(buf, new_ws)
        end
      end
    end
  end
end

-- Helper function to manage buffer listing state
local function set_buf_listed(bufnr, listed)
  if listed then
    vim.b[bufnr].WS_listed = nil
    vim.bo[bufnr].buflisted = true
  else
    vim.b[bufnr].WS_listed = true
    vim.bo[bufnr].buflisted = false
  end
end

-- Helper to get workspace ID for a buffer
local function get_buf_workspace(bufnr)
  return vim.b[bufnr] and vim.b[bufnr].WS
end

-- Helper to set workspace ID for a buffer
local function set_buf_workspace(bufnr, ws)
  if api.nvim_buf_is_valid(bufnr) then
    vim.b[bufnr].WS = ws
  end
end

-- Collect orphan buffers and assign to current workspace
local function collect_orphans()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 and not get_buf_workspace(buf) then
      set_buf_workspace(buf, vim.t.WS)
    end
  end
end

-- Hide buffers from other workspaces
local function hide_other_workspace_buffers()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    local buf_ws = get_buf_workspace(buf)
    if buf_ws and buf_ws ~= vim.t.WS then
      if vim.fn.buflisted(buf) == 1 then
        set_buf_listed(buf, false)
      end
    end
  end
end

-- Show buffers from current workspace
local function show_workspace_buffers()
  local bufs = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    local buf_ws = get_buf_workspace(buf)
    if buf_ws == vim.t.WS then
      if vim.b[buf].WS_listed then
        set_buf_listed(buf, true)
      end
      if vim.fn.buflisted(buf) == 1 then
        table.insert(bufs, buf)
      end
    end
  end
  vim.t.bufs = bufs
end

-- autocmds for tabufline -> store bufnrs on bufadd, bufenter events
-- enhanced with workspace management
autocmd({ "BufAdd", "BufEnter", "tabnew" }, {
  callback = function(args)
    local bufs = vim.t.bufs or {}
    local is_curbuf = cur_buf() == args.buf

    -- Set workspace for new buffer
    if not get_buf_workspace(args.buf) then
      set_buf_workspace(args.buf, vim.t.WS)
    end

    -- Handle buffer change to different workspace
    if args.event == "BufEnter" then
      local buf_ws = get_buf_workspace(args.buf)
      -- Update buffer workspace to current tab when opening file
      if buf_ws ~= vim.t.WS then
        set_buf_workspace(args.buf, vim.t.WS)
      end
      collect_orphans()
    end

    -- Check for duplicates and add buffer to list
    if
      not vim.tbl_contains(bufs, args.buf)
      and get_buf_workspace(args.buf) == vim.t.WS
      and (args.event == "BufEnter" or not is_curbuf or get_opt("buflisted", { buf = args.buf }))
      and api.nvim_buf_is_valid(args.buf)
      and get_opt("buflisted", { buf = args.buf })
    then
      table.insert(bufs, args.buf)
    end

    -- remove unnamed buffer which isnt current buf & modified
    if args.event == "BufAdd" then
      if #bufs > 0 and #api.nvim_buf_get_name(bufs[1]) == 0 and not get_opt("modified", { buf = bufs[1] }) then
        table.remove(bufs, 1)
      end
    end

    vim.t.bufs = bufs
  end,
})

autocmd("BufDelete", {
  callback = function(args)
    for _, tab in ipairs(api.nvim_list_tabpages()) do
      local bufs = vim.t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            table.remove(bufs, i)
            vim.t[tab].bufs = bufs
            break
          end
        end
      end
    end
  end,
})

-- Tab enter event - show workspace buffers
autocmd("TabEnter", {
  callback = function()
    -- Initialize workspace if not set
    if not vim.t.WS then
      vim.t.WS = get_next_ws_number()
    end

    -- Hide other workspace buffers and show current ones
    hide_other_workspace_buffers()
    show_workspace_buffers()
  end,
})

-- Tab leave event - mark buffers as hidden
autocmd("TabLeave", {
  callback = function()
    -- Mark all listed buffers in this workspace for hiding
    for _, buf in ipairs(vim.t.bufs or {}) do
      if vim.fn.buflisted(buf) == 1 then
        set_buf_listed(buf, false)
      end
    end
  end,
})

-- Tab closed event - renumber remaining workspaces
autocmd("TabClosed", {
  callback = function()
    -- Defer renumbering to let vim finish closing the tab
    vim.defer_fn(function()
      renumber_workspaces()
    end, 10)
  end,
})

if opts.lazyload then
  vim.api.nvim_create_autocmd({ "BufNew", "BufNewFile", "BufRead", "TabEnter", "TermOpen" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("TabuflineLazyLoad", {}),
    callback = function()
      if #vim.fn.getbufinfo { buflisted = 1 } >= 2 or #vim.api.nvim_list_tabpages() >= 2 then
        vim.o.showtabline = 2
        vim.o.tabline = "%!v:lua.require('sphynx.ui.tabufline.modules')()"
        vim.api.nvim_del_augroup_by_name "TabuflineLazyLoad"
      end
    end,
  })
else
  vim.o.showtabline = 2
  vim.o.tabline = "%!v:lua.require('sphynx.ui.tabufline.modules')()"
end

autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Workspace naming functions
local function set_workspace_name(name)
  if name and name ~= "" then
    vim.t.WSName = name
  end
end

local function get_workspace_name(tabnr_or_handle)
  -- If it's a number (tab index), get the handle
  if type(tabnr_or_handle) == "number" then
    local tabs = api.nvim_list_tabpages()
    local tab_handle = tabs[tabnr_or_handle]
    if tab_handle then
      return vim.t[tab_handle].WSName or tostring(vim.t[tab_handle].WS or tabnr_or_handle)
    end
    return tostring(tabnr_or_handle)
  else
    -- It's already a handle
    return vim.t[tabnr_or_handle].WSName or tostring(vim.t[tabnr_or_handle].WS or "?")
  end
end

-- Export functions for global use
_G.WS_SetName = set_workspace_name
_G.WS_GetName = get_workspace_name

-- Initialize workspace for existing tabs
local tab_count = 0
for _, tab in ipairs(api.nvim_list_tabpages()) do
  tab_count = tab_count + 1
  if not vim.t[tab].WS then
    vim.t[tab].WS = tab_count
  end
end

-- Assign existing buffers to current workspace on startup
collect_orphans()

-- User commands for workspace management
api.nvim_create_user_command('WSName', function(opts)
  set_workspace_name(opts.args)
end, { nargs = 1, desc = 'Set workspace name' })

api.nvim_create_user_command('WSList', function()
  local tabs = api.nvim_list_tabpages()
  local current = api.nvim_get_current_tabpage()
  for i, tab in ipairs(tabs) do
    local ws_num = vim.t[tab].WS or i
    local ws_name = vim.t[tab].WSName or tostring(ws_num)
    local prefix = tab == current and "▶ " or "  "
    print(prefix .. "Workspace " .. ws_num .. ": " .. ws_name)
  end
end, { desc = 'List all workspaces with names' })
