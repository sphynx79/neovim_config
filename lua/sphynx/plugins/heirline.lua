local M = {}

M.plugins = {
    ["heirline"] = {
        "rebelot/heirline.nvim",
        lazy = true,
        -- event = "UiEnter",
        cond = function ()
            return not vim.g.gonvim_running
        end,
    },
}

M.setup = {
    ["heirline"] = function()
        require("sphynx.utils.lazy_load").on_file_open "heirline.nvim"
    end,
}

M.configs = {
    ["heirline"] = function()
        vim.opt.laststatus = 3

        local heirline = require "heirline"
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")
        local colors = require("sphynx.colors").get_color()
        local sep = package.config:sub(1, 1)
        local file_changed = sep ~= '\\' and vim.loop.new_fs_event() or vim.loop.new_fs_poll()
        local Align = { provider = "%=" }
        local Space = { provider = " " }
        local Break = { provider = "%<"} -- this means that the statusline is cut here when there's not enough space
        local BigSpace = { provider = (" "):rep(5) }

        -- require("heirline").load_colors(colors)

        local function is_available(plugin)
            local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
            return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
        end

        local function update_branch(git_dir)
            file_changed:stop()
            local head_file = git_dir .. sep .. 'HEAD'
            local f_head = io.open(head_file)
            local head = f_head:read()
            f_head:close()
            file_changed:start(
                head_file,
                sep ~= '\\' and {} or 1000,
                vim.schedule_wrap(function()
                    -- reset file-watch
                    update_branch(git_dir)
                end)
            )
            return head:match('ref: refs/heads/(.+)$')
        end

        local ViMode = {
            -- get vim current mode, this information will be required by the provider
            -- and the highlight functions, so we compute it only once per component
            -- evaluation and store it as a component attribute
            init = function(self)
                self.mode = vim.fn.mode(1) -- :h mode()
            end,
            -- Now we define some dictionaries to map the output of mode() to the
            -- corresponding string and color. We can put these into `static` to compute
            -- them at initialisation time.
            static = {
                mode_names = { -- change the strings if yow like it vvvvverbose!
                    ['n']      = 'NORMAL',
                    ['no']     = 'O-PENDING',
                    ['nov']    = 'O-PENDING',
                    ['noV']    = 'O-PENDING',
                    ['no\22']  = 'O-PENDING',
                    ['niI']    = 'NORMAL',
                    ['niR']    = 'NORMAL',
                    ['niV']    = 'NORMAL',
                    ['nt']     = 'NORMAL',
                    ['v']      = 'VISUAL',
                    ['vs']     = 'VISUAL',
                    ['V']      = 'V-LINE',
                    ['Vs']     = 'V-LINE',
                    ['\22']    = 'V-BLOCK',
                    ['\22s']   = 'V-BLOCK',
                    ['s']      = 'SELECT',
                    ['S']      = 'S-LINE',
                    ['\19']    = 'S-BLOCK',
                    ['i']      = 'INSERT',
                    ['ic']     = 'INSERT',
                    ['ix']     = 'INSERT',
                    ['R']      = 'REPLACE',
                    ['Rc']     = 'REPLACE',
                    ['Rx']     = 'REPLACE',
                    ['Rv']     = 'V-REPLACE',
                    ['Rvc']    = 'V-REPLACE',
                    ['Rvx']    = 'V-REPLACE',
                    ['c']      = 'COMMAND',
                    ['cv']     = 'EX',
                    ['ce']     = 'EX',
                    ['r']      = 'REPLACE',
                    ['rm']     = 'MORE',
                    ['r?']     = 'CONFIRM',
                    ['!']      = 'SHELL',
                    ['t']      = 'TERMINAL',
                },
            },
            -- We can now access the value of mode() that, by now, would have been
            -- computed by `init()` and use it to index our strings dictionary.
            -- note how `static` fields become just regular attributes once the
            -- component is instantiated.
            -- To be extra meticulous, we can also add some vim statusline syntax to
            -- control the padding and make sure our string is always at least 2
            -- characters long
            provider = function(self)
                return "%2(" .. " " .. self.mode_names[self.mode] .. " " .. "%)"
            end,
            -- Re-evaluate the component only on ModeChanged event!
            -- Also allorws the statusline to be re-evaluated when entering operator-pending mode
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
        }

        local GitBranch = {
            condition = function(self)
                self.git_dir = ("%s".. sep .. ".git"):format(vim.loop.cwd())
                return vim.fn.isdirectory(self.git_dir) == 1
            end,

            init = function(self)
                self.branch = update_branch(self.git_dir)
            end,

            provider = function(self)
                return vim.trim(("%s %s"):format(#self.branch > 0 and "" or "", self.branch))
            end,

            hl = function(self)
                local color = self:mode_color()
                return { fg = color, bold = true }
            end,
        }

        local FileNameBlock = {
            -- let's first set up some attributes needed by this component and it's children
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
        }

        local FileIcon = {
            init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
                    filename,
                    extension,
                    { default = true }
                )
            end,

            provider = function(self)
                return self.icon and (" " .. self.icon .. " ")
            end,

            hl = function(self)
                return { fg = self.icon_color }
            end,
        }

        local FileName = {
            init = function(self)
                -- self.lfilename = vim.fn.fnamemodify(self.filename, ":t")
                self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
                if self.lfilename == "" then
                    self.lfilename = "[No Name]"
                end
                if not conditions.width_percent_below(#self.lfilename, 0.25) then
                    self.lfilename = vim.fn.pathshorten(self.lfilename)
                end
            end,

            flexible = 2,

            {
                provider = function(self)
                    return " " .. self.lfilename .. " "
                end,
            },
            {
                provider = function(self)
                   return " " .. vim.fn.pathshorten(self.lfilename)
                end,
            },
        }

        local FileFlags = {
            {
                condition = function()
                    return vim.bo.modified
                end,
                provider = "[+]",
                hl = { fg = colors.green },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "",
                hl = { fg = colors.orange },
            },
        }

        local FileNameModifer = {
            hl = function()
                if vim.bo.modified then
                    -- use `force` because we need to override the child's hl foreground
                    return { fg = colors.cyan, bold = true, force = true }
                end
            end,
        }

        local FileType = {
            FileIcon,
            {
                provider = function()
                    local buffer = vim.bo[self and self.bufnr or 0]
                    return string.upper(buffer.filetype)
                end,
                hl = { fg = colors.grey8 },
            },
        }

        local TerminalName = {
            -- condition = function()
            --     return vim.bo.buftype == 'terminal'
            -- end,
            -- icon = ' ', -- 
            {
                provider = function()
                    local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
                    return " " .. tname
                end,
                hl = { fg = colors.blue, bold = true },
            },
            { provider = " - " },
            {
                provider = function()
                    return vim.b.term_title
                end,
            },
            -- {
            --     provider = function()
            --         local id = require("terminal"):current_term_index() --[[ .active_terminals':get_current_buf_terminal():get_index() ]]
            --         return " " .. (id or "Exited")
            --     end,
            --     hl = { bold = true, fg = colors.blue },
            -- },
        }

        local LspClient = {

            static = {
                msg = "no active lsp",
                icon = " LSP: ",
            },

            init = function(self)
                self.buf_ft = vim.api.nvim_get_option_value('filetype' , { buf = 0 })
                self.clients = vim.lsp.get_clients({ bufnr = 0 })
            end,

            provider = function(self)
                if next(self.clients) == nil then return self.icon .. self.msg end
                for _, client in ipairs(self.clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, self.buf_ft) ~= -1 then
                        return self.icon .. client.name
                    end
                end
                return self.icon .. self.msg
            end,

            hl = { fg = colors.grey5 },

            update = {'LspAttach', 'LspDetach', 'WinEnter'},

            on_click = {
                name = "heirline_LSP",
                callback = function()
                    vim.schedule(function()
                    vim.cmd("LspInfo")
                end)
            end,
            },
        }

        -- local LspProgress = {

        --     condition = conditions.lsp_attached,

        --     static = {
        --         msg = "no active lsp",
        --         icon = " LSP: ",
        --     },

        --     init = function(self)
        --         -- self.messages = vim.lsp.util.get_progress_messages()
        --         self.buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        --         self.clients = vim.lsp.get_active_clients()
        --     end,

        --     provider = function(self)
        --         if #self.messages == 0 then
        --             return ""
        --         end
        --         local status = {}
        --         for _, msg in pairs(self.messages) do
        --             table.insert(status, " " .. (msg.percentage or 0) .. "%% " .. (msg.title or ""))
        --         end
        --         local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        --         local ms = vim.loop.hrtime() / 1000000
        --         local frame = math.floor(ms / 120) % #spinners
        --         return table.concat(status, " | ") .. " " .. spinners[frame + 1]
        --     end,

        --     hl = { fg = colors.grey5 },
        -- }

        local Path =  {
            provider = function(self)
                self.icon = " " .. " "
                self.path = vim.fn.fnamemodify(vim.fn.expand('%:h'), ':p:~:.')
            end,
            hl = { fg = colors.blue, bold = true },

            flexible = 1,

            {
                -- evaluates to the full-lenth path
                provider = function(self)
                    local trail = self.path:sub(-1) == sep and "" or sep
                    return self.icon .. self.path .. trail .." "
                end,
            },
            {
                -- evaluates to the shortened path
                provider = function(self)
                    local path = vim.fn.pathshorten(self.path)
                    local trail = self.path:sub(-1) == sep and "" or sep
                    return self.icon .. path .. trail .. " "
                end,
            },
            {
                -- evaluates to "", hiding the component
                provider = "",
            },
        }

        local Diagnostics = {
            condition = conditions.has_diagnostics,

            static = {
                error_icon = ' ',
                warn_icon = '  ',
                info_icon = '  ',
                hint_icon = '  ',
            },

            init = function(self)
                    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,

            on_click = {
                name = "heirline_diagnostic",
                callback = function()
                    if is_available "telescope.nvim" then
                        require("telescope.builtin").diagnostics()
                    end
                end,
            },

            update = { "DiagnosticChanged", "BufEnter" },

            {
                provider = " [",
            },
            {
                provider = function(self)
                    -- 0 is just another output, we can decide to print it or not!
                    return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                end,
                hl = { fg =  colors.red},
            },
            {
                provider = function(self)
                    return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                end,
                hl = { fg = colors.magenta },
            },
            {
                provider = function(self)
                    return self.info > 0 and (self.info_icon .. self.info .. " ")
                end,
                hl = { fg = colors.green },
            },
            {
                provider = function(self)
                    return self.hints > 0 and (self.hint_icon .. self.hints)
                end,
                hl = { fg = colors.blue },
            },
            {
                provider = "]",
            },
        }

        local Progress = {
            provider = '%3p%%',

            hl = function(self)
                local color = self:mode_color() -- here!
                return { fg = color, bold = true }
            end
        }

        local Location = {
            provider = '%3l:%-2v',
        }

        local ScrollBar = {
            static = {
                sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
            },
            provider = function(self)
                local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                local lines = vim.api.nvim_buf_line_count(0)
                local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
                return string.rep(self.sbar[i], 2)
            end,
            hl = function(self)
                return { fg = colors.yellow, bold = true }
            end
        }

        local HelpFilename = {
            condition = function()
                return vim.bo.filetype == "help"
            end,
            provider = function()
                local filename = vim.api.nvim_buf_get_name(0)
                return vim.fn.fnamemodify(filename, ":t")
            end,
            hl = { fg = colors.blue, bold = true },
        }

        -- let's add the children to our FileNameBlock component
        FileNameBlock = utils.insert(
            FileNameBlock,
            FileIcon,
            utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
            unpack(FileFlags) -- A small optimisation, since their parent does nothing
        )

        ViMode = utils.surround({ "", "" }, function(self) return self:mode_color() end, {ViMode, hl = {fg = colors.grey14, bold = true}} )

        Location = utils.surround({ "", "" }, function(self) return self:mode_color() end, {Location, Space,  hl = {fg = colors.grey14, bold = true}} )

        local DefaultStatusline = {
            ViMode,
            Space,
            GitBranch,
            Path,
            Diagnostics,
            Break,
            Align,
            LspClient, Align,
            FileType,
            Space,
            ScrollBar,
            Space,
            Location,
        }

        local SpecialStatusline = {
            condition = function()
                return conditions.buffer_matches({
                    filetype = { "NvimTree", "dbui", "packer", "startify", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "help", "quickfix", "terminal" },
                })
            end,
            FileType,
            { provider = "%q" },
            Space,
            HelpFilename,
            Align,
        }

        local StatusLines = {
            hl = function()
                return {
                    fg = colors.grey10,
                    bg = colors.grey13,
                }
            end,

            static = {
                mode_colors = {
                    n = colors.cyan,
                    i = colors.green,
                    v = colors.cyan,
                    V = colors.cyan,
                    ["\22"] = colors.cyan, -- this is an actual ^V, type <C-v><C-v> in insert mode
                    c = colors.yellow,
                    s = colors.magenta,
                    S = colors.magenta,
                    ["\19"] = colors.pink, -- this is an actual ^S, type <C-v><C-s> in insert mode
                    R = colors.orange,
                    r = colors.orange,
                    ["!"] = colors.red,
                    t = colors.green,
                },
                mode_color = function(self)
                    local mode = vim.fn.mode() or "n"
                    return self.mode_colors[mode]
                end,
            },

            fallthrough = false,
            SpecialStatusline,
            DefaultStatusline,
        }

        local CloseButton = {
            condition = function(self)
                return not vim.bo.modified
            end,
            -- update = 'BufEnter',
            update = { "WinNew", "WinClosed", "BufEnter" },
            { provider = " " },
            {
                provider = "",
                hl = function()
                    if conditions.is_not_active() then
                        return { fg = "gray", force = true }
                    else
                        return { fg = colors.red, force = true }
                    end
                end,

                on_click = {
                    callback = function(_, minwid)
                        vim.api.nvim_win_close(minwid, true)
                    end,
                    minwid = function()
                        return vim.api.nvim_get_current_win()
                    end,
                    name = "heirline_winbar_close_button",
                },
            },
        }

        local WinBar = {
            init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
            fallthrough = false,

            {
                condition = function()
                    return conditions.buffer_matches({ buftype = { "terminal" } })
                end,
                utils.surround({ "", "" }, colors.grey13, {
                    FileType,
                    Space,
                    TerminalName,
                    CloseButton,
                }),
            },

            {
                condition = function()
                    return not conditions.is_active()
                end,
                {
                    BigSpace,
                    {
                        FileNameBlock,
                        hl = { fg = "gray", bold = true, force = true }
                    },
                    {
                        CloseButton,
                        provider = nil,
                        Align,
                        { provider = ""},
                        hl = { bg = colors.bg1, force = true },
                    }
                },
            },

            {
                BigSpace,
                {
                    FileNameBlock,
                    hl = { fg = colors.blue, bold = true, force = true },
                },
                {
                    CloseButton,
                    provider = nil,
                    Align,
                    { provider = ""},
                    hl = { bg = colors.bg1, force = true },
                }
            },
        }

        heirline.setup({
            statusline = StatusLines,
            winbar = WinBar,
            opts = {
                -- if the callback returns true, the winbar will be disabled for that window
                -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
                disable_winbar_cb = function(args)
                    local buf = args.buf
                    local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
                    local filetype = vim.tbl_contains({ "gitcommit", "fugitive", "Trouble", "lazy" }, vim.bo[buf].filetype)
                    return buftype or filetype
                end,
            },
        })
        -- vim.o.statuscolumn = require("heirline").eval_statuscolumn()


        vim.api.nvim_create_augroup("Heirline", { clear = true })
        -- TODO: vedere se questa opzione in Heirline serve
        vim.cmd([[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])

        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                local color = require("sphynx.colors").get_color()
                utils.on_colorscheme(color)
            end,
            group = "Heirline",
        })
    end,
}

return M

