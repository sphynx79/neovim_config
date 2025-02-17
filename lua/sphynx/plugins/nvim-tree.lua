-- NOTE: PLUGIN: nvim-tree-preview.lua
-- DESCRIZIONE:
-- File explorer per neovim
--    PLUGIN: nvim-tree-preview.lua
--    DESCRIZIONE:
--    Mi permette di aprire la preview del file
--    MAPPING:
--    <Tab> => mi mostra la preview
--    se ancora <Tab> si sposta nella preview
--    se ancora <Tab> si mette ancora nella lista dei file
--    mentre sono in Preview:
--    <CR>  Apre il file
--    <C-v> Apre il file in vertical window
--    <C-x> Apre il file in horizontal window
--    <C-t> Apre il file in new tab
--    <C-V> Apre il file in vertical window
--    PLUGIN: nvim-window-picker
--    DESCRIZIONE:
--    Mi permette di aprire il file in una psecifica finestra
--    Vedere il file di configurazone del plugin [nvim-window-picker]


local M = {}

M.plugins = {
    ["nvim-tree.lua"] = {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
        dependencies = {
            'b0o/nvim-tree-preview.lua'
        },
    },
}

M.setup = {
    ["nvim-tree.lua"] = function()
        M.keybindings()
    end,
}

M.configs = {
    ["nvim-tree.lua"] = function()

        local function on_attach(bufnr)
            local api = require('nvim-tree.api')
            local preview = require('nvim-tree-preview')

            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end


            -- Default mappings. Feel free to modify or remove as you wish.
            --
            -- BEGIN_DEFAULT_ON_ATTACH
            vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
            vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
            vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
            vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
            vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
            vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
            vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
            vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
            vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
            -- vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
            vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
            vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
            vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
            vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
            vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
            vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
            vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
            vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
            vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
            vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
            vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
            vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
            vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
            vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
            vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
            vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
            vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
            vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
            vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
            vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
            vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
            vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
            vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
            vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
            vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
            vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
            vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
            vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
            vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
            -- vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
            vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
            vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
            vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
            vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
            vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
            vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
            vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
            vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
            vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
            vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
            vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
            vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
            -- END_DEFAULT_ON_ATTACH

            -- Mappings migrated from view.mappings.list
            --
            -- You will need to insert "your code goes here" for any mappings with a custom action_cb
            vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
            -- vim.keymap.set('n', 'P', function()
            --     local node = api.tree.get_node_under_cursor()
            --     print(node.absolute_path)
            -- end, opts('Print Node Path'))

            vim.keymap.set('n', 'Z', api.node.run.system, opts('Run System'))

            -- Preview keys
            vim.keymap.set('n', 'P', preview.watch, opts 'Preview (Watch)')
            vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
            vim.keymap.set('n', '<Tab>', function()
                local ok, node = pcall(api.tree.get_node_under_cursor)
                if ok and node then
                    if node.type == 'directory' then
                        api.node.open.edit()
                    else
                        preview.node(node, { toggle_focus = true })
                    end
                end
            end, opts 'Preview')
        end

        require("nvim-tree").setup({
            disable_netrw = true,
            hijack_netrw = false,
            update_cwd = true,
            update_focused_file = {
                enable = false,
            },
            filters = {
                custom = { ".git", "node_modules", ".cargo", "\\.cache" },
            },
            git = {
                enable = false,
            },
            diagnostics = {
                enable = false,
                icons = {hint = "", info = "", warning = "", error = ""},
            },
            renderer = {
                add_trailing = true,
                root_folder_label = false,
                highlight_opened_files = "none",
                indent_markers = {
                    enable = true,
                }
            },
            view = {
                side = 'left',
                width = 30,
                -- mappings = {
                --     list = {
                --         { key = "?", action = "toggle_help" }
                --     }
                -- }
            },
            actions = {
                use_system_clipboard = true,
                change_dir = {
                    enable = true,
                    global = false,
                    restrict_above_cwd = false,
                },
                open_file = {
                    quit_on_open = false,
                    resize_window = false,
                    window_picker = {
                        enable = true,
                        picker = function()
                            return require('window-picker').pick_window {
                                filter_rules = {
                                file_path_contains = { 'nvim-tree-preview://' },
                            },
                        }
                        end,
                        -- chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                        -- exclude = {
                        --     filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        --     buftype = { "nofile", "terminal", "help" },
                        -- },
                    },
                },
            },
            on_attach = on_attach,
        })

        require('nvim-tree-preview').setup {
            -- Keymaps for the preview window (does not apply to the tree window).
            -- Keymaps can be a string (vimscript command), a function, or a table.
            --
            -- If a table, it must contain either an 'action' or 'open' key:
            --
            -- Actions:
            --   { action = 'close', unwatch? = false, focus_tree? = true }
            --   { action = 'toggle_focus' }
            --
            -- Open modes:
            --   { open = 'edit' }
            --   { open = 'tab' }
            --   { open = 'vertical' }
            --   { open = 'horizontal' }
            --
            -- To disable a default keymap, set it to false.
            -- All keymaps are set in normal mode. Other modes are not currently supported.
            keymaps = {
                ['<Esc>'] = { action = 'close', unwatch = true },
                ['P'] = { action = 'toggle_focus' },
                ['<CR>'] = { open = 'edit' },
                ['<C-t>'] = { open = 'tab' },
                ['<C-v>'] = { open = 'vertical' },
                ['<C-x>'] = { open = 'horizontal' },
            },
            title_pos = 'top-left',
            min_width = 10,
            min_height = 5,
            max_width = 85,
            max_height = 25,
            wrap = false, -- Whether to wrap lines in the preview window
            border = 'single', -- Border style for the preview window
        }


     end,
}

M.keybindings = function()
        local mapping = require("sphynx.core.5-mapping")
        mapping.register({
            {
                mode = { "n", "i", "v" },
                lhs = "<F4>",
                rhs = "<cmd>NvimTreeToggle<cr>",
                -- rhs = function()
                --     aux.toggle_sidebar("NvimTree")
                --     vim.cmd("NvimTreeToggle")
                -- end,
                options = { silent = true },
                description = "Open File Explorer",
            },
            {
                mode = { "n", "i", "v" },
                lhs = "<F3>",
                rhs = "<cmd>NvimTreeFindFile<cr>",
                options = { silent = true },
                description = "Find the current file and open it in file explorer",
            },
            {
                mode = { "n", "i", "v" },
                lhs = "<F2>",
                rhs = "<cmd>NvimTreeFocus<cr>",
                options = { silent = true },
                description = "Set focus in file explorer",
            },
        })
end

return M


