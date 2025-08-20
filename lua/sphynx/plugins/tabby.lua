local M = {}

M.plugins = {
    ["tabby"] = {
        "nanozuki/tabby.nvim",
        lazy = true,
        event = "VeryLazy",
    },
}

M.configs = {
    ["tabby"] = function()
        vim.o.showtabline = 2
        -- if conf.alwaysShow then vim.o.showtabline = 2 end

        local api = require('tabby.module.api')
        -- local win_name = require('tabby.feature.win_name')
        -- local getBufOpt = vim.api.nvim_set_option_value

        local theme = {
            fill = 'TabLineFill',
            -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
            head = 'TabLine',
            current_tab = {fg = '#22262F', bg = '#7B99B8', style='bold' },
            tab = {fg = '#bbc2d0', bg = '#6F7B93'},
            current_buf = 'TabLineSel',
            buf = { fg = '#787e87', bg = '#3b4252' },
            separator = { fg = '#787e87', bg = '#3b4252' },
        }

        local function createLogo(line)
            return {
                { '  ', hl = { fg = '#8fbcbb', bg = '#3b4252' } },
                -- { '│', hl = theme.separator },
                line.sep('', theme.head, theme.fill),
            }
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
        local function renderBuffer(buf, i, count)
            local hl = buf.is_current() and theme.current_buf or theme.buf
            return {
                buf.is_current() and '' or '',
                buf.file_icon(),
                ' ',
                buf.name(),
                buf.is_changed() and ' ●' or '',
                -- Aggiungi separatore solo se non è l'ultimo buffer
                i < count and ' │' or '',
                hl = hl,
                margin = ' ',
            }
        end

        local function renderTab(tab, i, count)
            local hl = tab.is_current() and theme.current_tab or theme.tab

            -- Indicatore visuale diverso per stati diversi
            local prefix = ''
            if tab.in_jump_mode() then
                prefix = '[' .. tab.jump_key() .. '] ' -- [a] in jump mode
            else
                prefix = '' -- spazio per allineamento
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

                return {

                    -- Header/Logo
                    createLogo(line),

                    -- Buffer section con filtro
                    line.bufs()
                        .filter(filterBuffers)
                        .foreach(renderBuffer),

                    -- Spacer centrale
                    line.spacer(),

                    -- Tab section
                    show_tabs and line.tabs().foreach(renderTab) or '',
                    -- line.tabs().foreach(renderTab),

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
        -- === KEYBINDINGS ===
        local opts = { noremap = true, silent = true }

        -- Tab navigation con Alt
        for i = 1, 9 do
            vim.keymap.set('n', '<A-' .. i .. '>', i .. 'gt', opts)
        end

        -- Tab management
        local tab_keys = {
            ['<leader>tn'] = ':tabnew<CR>',
            ['<leader>tc'] = ':tabclose<CR>',
            ['<leader>to'] = ':tabonly<CR>',
            ['<leader>th'] = ':tabprevious<CR>',
            ['<leader>tl'] = ':tabnext<CR>',
            ['<leader>t<'] = ':-tabmove<CR>',
            ['<leader>t>'] = ':+tabmove<CR>',
            ['<leader>tj'] = ':Tabby jump_to_tab<CR>',
            ['<leader>tw'] = ':Tabby pick_window<CR>',
        }

        for key, cmd in pairs(tab_keys) do
            vim.keymap.set('n', key, cmd, opts)
        end

        -- Rinomina tab con funzione interattiva
        vim.keymap.set('n', '<leader>tr', function()
            vim.ui.input({ prompt = 'Nome tab: ' }, function(name)
                if name and name ~= '' then
                    vim.cmd('Tabby rename_tab ' .. name)
                end
            end)
        end, { desc = 'Rinomina tab' })

        -- Buffer navigation
        local buf_keys = {
            ['<leader>bp'] = ':bprevious<CR>',
            ['<leader>bn'] = ':bnext<CR>',
            ['<leader>bd'] = ':bdelete<CR>',
        }

        for key, cmd in pairs(buf_keys) do
            vim.keymap.set('n', key, cmd, opts)
        end

        -- Buffer picker veloce
        vim.keymap.set('n', '<leader>bb', ':buffer ', { noremap = true })

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

return M
saas
