-- vim: set sw=2 ts=2 sts=2 et tw=120 foldmarker=--{{{,--}}} foldmethod=marker nospell:

--{{{ Global Utils
  _G.P = function(v)
    vim.print(v)
    return v
  end

  _G.R = function(name)
      require("lazy").reload(name)
      require("plenary.reload").reload_module(name)
      return require(name)
  end

  _G.reload_options = function()
    vim.opt.viewoptions:remove('options')
    vim.cmd("silent mkview |" )
    dofile(sphynx.path.nvim_config .. "/lua/sphynx/core/1-settings.lua")
    vim.cmd(" | loadview")
    vim.opt.viewoptions:prepend('options')
  end

  _G.custom_fold_text = function()
      local line = vim.fn.getline(vim.v.foldstart)
      local line_count = vim.v.foldend - vim.v.foldstart + 1
      return "  ⚡ " .. line .. ": " .. line_count .. " lines"
  end
--}}} Global Utils

--{{{ Utils for sphynx-nvim
  local utils = {}
  local api = vim.api
  local fn = vim.fn

  function utils.join_path(...)
    return table.concat(vim.tbl_flatten({ ... }), "/")
  end

  function utils.define_augroups(definitions)
    -- Create autocommand groups basedsphynx.path on the passed definitions
    for group_name, definition in pairs(definitions) do
      vim.api.nvim_create_augroup(group_name, {clear = true})

      for _, def in pairs(definition) do
        local event = def["event"]
        local opts  = def["opts"]
        vim.api.nvim_create_autocmd(event, opts)
      end
    end
  end

--}}} Utils for sphynx-nvim

function utils.plugin_is_installed(plugin_name)
    local plugins = vim.tbl_map(function(plugin)
        return plugin.name
    end, require("lazy").plugins())

    for _, value in pairs(plugins) do
        if value == plugin_name then return true end
    end
    return false
end


function utils.set_shell_title()
  local cwd = fn.getcwd(0)
  cwd = fn.fnamemodify(cwd, ":~")
  vim.o.titlestring = fn.pathshorten(cwd,3)
end

function utils.check_time()
  if api.nvim_get_mode().mode == "n" and fn.getcmdwintype() == "" then
    vim.cmd [[checktime]]
  end
end

function utils.close_buffer(bufnr)
   if vim.bo.buftype == "terminal" then
      if vim.bo.buflisted then
         vim.bo.buflisted = false
         vim.cmd "enew"
      else
         vim.cmd "hide"
      end
      return
   end

   -- if file doesnt exist & its modified
   if vim.bo.modified then
      print "save the file!"
      return
   end

   bufnr = bufnr or api.nvim_get_current_buf()
   require("sphynx.utils").tabuflinePrev()
   -- vim.cmd("bd" .. bufnr)
   vim.api.nvim_buf_delete(bufnr, { force = false })
end

function utils.bufilter()
   local bufs = vim.tbl_filter(function(b)
        return 1 == fn.buflisted(b)
   end, api.nvim_list_bufs())

   for i = #bufs, 1, -1 do
      if not api.nvim_buf_is_valid(bufs[i]) then
         table.remove(bufs, i)
      end
   end

   return bufs
end

function utils.tabuflineNext()
   local bufs = utils.bufilter() or {}

   for i, v in ipairs(bufs) do
      if api.nvim_get_current_buf() == v then
         vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
         break
      end
   end
end

function utils.tabuflinePrev()
   local bufs = utils.bufilter() or {}

   for i, v in ipairs(bufs) do
      if api.nvim_get_current_buf() == v then
         vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
         break
      end
   end
end

-- closes tab + all of its buffers
function utils.closeAllBufs(action)
   local bufs = vim.tbl_filter(function(b)
        return 1 == fn.buflisted(b)
   end, vim.api.nvim_list_bufs())


   for _, buf in ipairs(bufs) do
      utils.close_buffer(buf)
   end

   vim.cmd(action == "closeTab" and "tabclose" or "enew")
   --vim.cmd("enew")
   --vim.cmd("NvimTreeOpen")
end

function utils.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function utils.info(msg, name)
  utils.log(msg, "LspDiagnosticsDefaultInfo", name)
end

function utils.warn(msg, name)
  utils.log(msg, "LspDiagnosticsDefaultWarning", name)
end

function utils.error(msg, name)
  utils.log(msg, "LspDiagnosticsDefaultError", name)
end

function utils.toggle_fold()
  if vim.api.nvim_get_option_value("foldclose", { }) == "all" then
    utils.info("Fold auto disable", "Fold")
    vim.cmd([[set foldclose&]])
  else
    utils.info("Fold auto enabled", "Fold")
    vim.opt.foldclose = "all"
  end
end

function utils.toggle_qf()
  local qf_open = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_open = true
    end
  end
  if qf_open == true then
    vim.cmd("cclose")
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  end
end



return utils
