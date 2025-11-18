local M = {}

M.plugins = {
    ["tabby"] = {
        "nanozuki/tabby.nvim",
        lazy = true,
        event = "VeryLazy",
    },
}

M.setup = {
    ["tabby"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["tabby"] = function()
        vim.o.showtabline = 2
        -- if conf.alwaysShow then vim.o.showtabline = 2 end

        -- local win_name = require('tabby.feature.win_name')
        -- local getBufOpt = vim.api.nvim_set_option_value
        local colors = require("sphynx.colors").get_color()

        local theme = {
            fill = { bg = colors.grey11 },
            TabLineLogo = { fg = colors.cyan, bg = colors.grey13 },
            TabLineaPadding = { bg = colors.grey13 },
            TabLineWinCur = { fg = colors.blue, bg = colors.bg1 },
            TabLineWinSepCur = { fg = colors.blue, bg = colors.bg1 },
            TabLineWin = { fg = colors.grey1, bg = colors.grey11 },
            TabLineWinSep = { fg = colors.grey10, bg = colors.grey11 },
            TabLineBufCurModified = { fg = colors.yellow, bg = colors.bg1 },
            TabLineBufModified = { fg = colors.yellow, bg = colors.grey11 },
            head = 'TabLine',
            current_tab = { fg = '#22262F', bg = '#7B99B8', style = 'bold' },
            tab = { fg = '#bbc2d0', bg = '#6F7B93' },
            current_buf = 'TabLineSel',
            buf = { fg = '#787e87', bg = '#3b4252' },
            separator = { fg = '#787e87', bg = '#3b4252' },
            TabLineTab = { fg = colors.grey9, bg = colors.bg },
            TabLineTabCur = { fg = colors.bg, bg = colors.grey9 },
            TabLineTabSepCur = { fg = colors.grey9, bg = colors.bg },
        }

        local function createLogo(line)
            return {
                { '  ', hl = theme.TabLineLogo },
                { '', hl = theme.TabLineLogo },
                -- line.sep('', theme.head, theme.fill),
                -- line.sep('│', theme.head, theme.logo ),
            }
        end

        local function get_nvimtree_padding()
            local api = vim.api
            local current_tab = api.nvim_get_current_tabpage()
            local wins = api.nvim_tabpage_list_wins(current_tab)
            local logo_width = 3       -- 1 spazio + icona + 1 spazio

            local nvimtree_width = 0
            local has_normal_window = false

            for _, win in ipairs(wins) do
                local buf = api.nvim_win_get_buf(win)
                local ft = api.nvim_get_option_value('filetype', { buf = buf })

                -- finestra NvimTree: usiamo la sua larghezza come padding
                if ft == 'NvimTree' then
                    nvimtree_width = api.nvim_win_get_width(win) - logo_width
                else
                    -- se c'è almeno una finestra "normale", la segniamo
                    local bt = api.nvim_get_option_value('buftype', { buf = buf })
                    if bt == '' then
                        has_normal_window = true
                    end
                end
            end

            -- Se vuoi padding SOLO quando è aperto solo NvimTree (nessuna finestra "normale"):
            -- if nvimtree_width > 0 and not has_normal_window then
            --     return nvimtree_width
            -- end
            -- return 0

            -- Versione semplice: metti padding ogni volta che NvimTree è aperto
            return nvimtree_width
        end

        local function filterBuffers(buf)
            local name = buf.name()
            local excluded = { 'NvimTree', 'neo-tree', 'TelescopePrompt', 'qf', 'help' }
            for _, pattern in ipairs(excluded) do
                if name:match(pattern) then
                    return false
                end
            end
            return true
        end

        -- Funzione per renderizzare un singolo buffer
        local function renderBuffer(buf, i, count, line)
            local hl, pre
            local preSym = '▌'
            local preSym_cur = '▏'



            if buf.is_current() then
                hl = theme.TabLineWinCur
                pre = { preSym .. ' ', hl = theme.abLineWinSepCur }
            else
                hl = theme.TabLineWin
                pre = { preSym_cur .. ' ', hl = theme.TabLineWinSep }
            end

            local icon = buf.file_icon()
            if icon then
                icon = icon .. ' '
            else
                icon = ''
            end


            return {
                pre,
                icon,
                buf.name(),
                {
                    buf.is_changed() and '● ' or '  ',
                    hl = buf.is_current() and theme.TabLineBufCurModified or theme.TabLineBufModified,
                },
                hl = hl,
            }
        end

        local function renderTab(tab, i, count)
            local hl = tab.is_current() and theme.current_tab or theme.tab

            -- Indicatore visuale diverso per stati diversi
            local prefix = ''
            if tab.in_jump_mode() then
                prefix = '[' .. tab.jump_key() .. '] ' -- [a] in jump mode
            else
                prefix = ''                            -- spazio per allineamento
            end

            return {
                prefix,
                tab.name(),
                tab.is_current() and '' or '', -- spazio extra per current
                tab.close_btn('×'),
                -- i < count and '│' or '',
                i < count and '  ' or '',
                hl = hl,
                margin = ' ',
            }
        end

        -- Componente tail per i tab
        local function createTabSection(line)
            return {
                line.sep('', theme.head, theme.fill),
                { '  ', hl = theme.head },
            }
        end


        require("tabby").setup({
            option = {
                buf_name = {
                    mode = 'unique',
                    name_fallback = function(bufid)
                        return '[No Name]'
                    end,
                },
                tab_name = {
                    name_fallback = function(tabid)
                        -- Nome intelligente basato sul contenuto del tab
                        local wins = vim.api.nvim_tabpage_list_wins(tabid)
                        if #wins > 0 then
                            local bufid = vim.api.nvim_win_get_buf(wins[1])
                            local path = vim.api.nvim_buf_get_name(bufid)
                            if path ~= '' then
                                local project = vim.fn.fnamemodify(path, ':p:h:t')
                                return project ~= '' and project or 'Tab'
                            end
                        end
                        return 'Tab'
                    end,
                },
            },
            line = function(line)
                local tab_count = vim.fn.tabpagenr('$')
                local show_tabs = tab_count > 1

                -- calcola padding dinamico in base a NvimTree
                local nvimtree_padding = get_nvimtree_padding()
                local padding_node = ''

                if nvimtree_padding > 0 then
                    -- puoi ridurre/scala­re il padding se ti sembra troppo
                    padding_node = { string.rep(' ', nvimtree_padding), hl = theme.TabLineaPadding }
                end

                return {

                    -- Header/Logo
                    createLogo(line),

                    -- Padding a sinistra quando NvimTree è aperto
                    padding_node,

                    -- Buffer section con filtro
                    line.bufs()
                        .filter(filterBuffers)
                        .foreach(renderBuffer),

                    -- Spacer centrale
                    line.spacer(),

                    -- Tab section
                    show_tabs and line.tabs().foreach(renderTab) or '',

                    -- Tail
                    show_tabs and createTabSection(line) or '',
                    -- createTabSection(line),

                    -- Background generale
                    hl = theme.fill,
                }
            end
        })

        -- Configurazione highlight personalizzata (opzionale)
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = function()
                vim.api.nvim_set_hl(0, 'TabLineSel', {
                    fg = '#ffffff',
                    bg = '#005f87',
                    bold = true
                })
                vim.api.nvim_set_hl(0, 'TabLine', {
                    fg = '#a8a8a8',
                    bg = '#3b4252'
                })
                vim.api.nvim_set_hl(0, 'TabLineFill', {
                    fg = '#a8a8a8',
                    bg = '#3b4252'
                })
                vim.api.nvim_set_hl(0, 'TabLineSep', {
                    fg = '#787e87',
                    bg = '#3b4252'
                })
            end,
        })

        -- Settings
        vim.o.showtabline = 2
        vim.opt.sessionoptions:append({ 'tabpages', 'globals' })

        -- === FUNZIONI UTILITY AGGIUNTIVE (opzionali) ===

        -- Chiudi tutti i buffer tranne il corrente
        vim.api.nvim_create_user_command('BufOnly', function()
            vim.cmd('%bdelete|edit#|bdelete#')
        end, {})

        -- Chiudi buffer senza chiudere finestra
        vim.api.nvim_create_user_command('Bd', function()
            local current = vim.fn.bufnr('%')
            vim.cmd('bnext')
            vim.cmd('bdelete ' .. current)
        end, {})
    end,
}

M.keybindings = function()
    local mapping = require("sphynx.core.5-mapping")
    local wk = require("which-key")
    local prefix = "w"

    local function rename_tab()
        vim.ui.input({ prompt = 'Nome tab: ' }, function(name)
            if name and name ~= '' then
                vim.cmd('Tabby rename_tab ' .. name)
            end
        end)
    end

    wk.add({
        { "<leader>" .. prefix, group = "  Workspace" },
        { "<leader>" .. prefix .. "r", rename_tab, desc = "Rinomina tab [Tabby]" },
        { "<leader>" .. prefix .. "n", [[<Cmd>tabnew<CR>]], desc = "Tab new [Tabby]" },
        { "<leader>" .. prefix .. "j", [[<Cmd>Tabby jump_to_tab<CR>]], desc = "Jump to Tab [Tabby]" },
        { "<leader>" .. prefix .. "w", [[<Cmd>Tabby pick_window<CR>]], desc = "Pick window tab [Tabby]" },
        { "<leader>" .. prefix .. "<Left>", [[<Cmd>tabprevious<CR>]], desc = "Tab left [Tabby]" },
        { "<leader>" .. prefix .. "<Right>", [[<Cmd>tabnext<CR>]], desc = "Tab right [Tabby]" },
        { "<leader>" .. prefix .. "c", group = " Close [Tabby]" },
        { "<leader>" .. prefix .. "c" .. "c", [[<Cmd>lua require('sphynx.utils').closeAllBufs('closeTab')<CR>]], desc = "Close current tab [utils=>init.lua]" },
        { "<leader>" .. prefix .. "c" .. "#", desc = "Close tab .N [Workspace]" },
        { "<leader>" .. prefix .. "m", group = "󰆾 Move" },
        { "<leader>" .. prefix .. "m" .. "<Left>", [[<Cmd>:-tabmove<CR>]], desc = "Move tab left [Tabby]" },
        { "<leader>" .. prefix .. "m" .. "<Right>", [[<Cmd>:+tabmove<CR>]], desc = "Move tab right [Tabby]" },
    }, mapping.opt_mappping)

    -- Close tab .N
    for i = 1, 10 do
        wk.add({
            { "<leader>" .. prefix .. "c" .. tostring(i),  [[<Cmd>lua vim.cmd("WS ]] .. tostring(i) .. [[") require('sphynx.utils').closeAllBufs('closeTab')<CR>]], hidden = true },
        }, mapping.opt_mappping)
    end

end

return M
