--{{{ Modeline and Notes
-- vim: set sw=2 ts=2 sts=2 et tw=120 foldmarker=--{{{,--}}} foldmethod=marker nospell:

    --{{{ Header
        --[[
            Maintainer:
                miboscol@gmail.com
            Version:
                2.0 - 10/11/15 09:26:00
            Blog_post:
                http:/.............
            Sections:
                -> General
                    -> Identify platform
                    -> Stratup Vim-Plug
                    -> Environment
                        -> Files, backups and undo
                        -> Tab and indent relate
                        -> Folding
                -> UI Setting
                -> Key Setting
                -> Shortcut => Folding
                -> Shortcut => Moving aroundg
                -> Shortcut => Buffer & window
                -> Shortcut => Editing
                -> Shortcut => Visualization
                -> Shortcut => Search & Replace
                -> Shortcut => Ctags
                -> Shortcut => Diff mode
                -> Language Support
                    -> Ruby & Rails
                    -> Xml
                -> Plugin
                    -> Airline
                    -> AutoFormat
                    -> CtrlSpace
                    -> Dash
                    -> EasyTag
                    -> GoldenView
                    -> IndentLine
                    -> MakeHeader
                    -> Maximizer
                    -> NerdTree
                    -> Signature
                    -> Tabular
                    -> Tagbar
                    -> Tcomment
                    -> Ultisnip
                -> Autocmd
                -> Helper functions
            --]]
    --}}} Header

--}}} Modeline and Notes

local cmd = vim.cmd
local utils = require("sphynx.utils")

--{{{ Identify platform
    local is_osx = function()
        return (vim.fn.has("macunix") == 1)
    end
    local is_linux = function()
        return ((vim.fn.has("unix") == 1) and (vim.fn.has("macunix") == 1 ) and not(vim.fn.has("win32unix") == 1))
    end
    local is_windows = function()
        return ((vim.fn.has("win16") == 1 ) or (vim.fn.has("win32") == 1) or (vim.fn.has("win64") == 1))
    end

    vim.g.is_nvim = (vim.fn.has("nvim") == 1)
    vim.g.is_nvim_qt = (vim.fn.exists("*nvim_list_uis") == 1) and (vim.api.nvim_list_uis()[1]["chan"] == 1)
    vim.g.is_gui_running = (vim.fn.has("gui_running") == 1) or vim.g.is_nvim_qt
--}}} Identify platformgui_runn

--{{{ Set before all
    cmd([[let did_install_default_menus=1]])
    cmd([[let did_install_syntax_menu=1]])
    -- Disabilito il vimrc che in vim 8 veniva caricato di default
    vim.cmd([[let skip_defaults_vim=1]])
    vim.opt.termguicolors = true -- True color support
    vim.opt.mouse = "a" -- enable mouse mode
    vim.g.local_config = vim.fn.expand("./vim-dev")
    if vim.fn.filereadable(vim.g.local_config) ~= 0 then
        print("Leggo file vimrc locale")
        cmd('source ' .. vim.g.local_config)
    end
--}}} Set before all

--{{{ General

    --{{{ Windows Config
        if is_windows() then
            -- Load windows support
            vim.cmd('source ' .. vim.fn.expand(sphynx.path.nvim_config .. '/mswin.vim'))
        end
    --}}} Windows Config

    --{{{ Global
        -- Sets how many lines of history has to remember
        vim.opt.history = 200
        -- '1000: Salva fino a 1000 comandi nella cronologia.
        --  <150: Salva fino a 150 righe di ricerca.
        -- s30: Salva lo stato per 30 sessioni di Neovim.
        -- h: Mantieni la cronologia anche dopo il riavvio.
        vim.opt.shada = "'1000,<150,s30,h"
        -- Backspace and cursor keys wrap too
        vim.opt.whichwrap:prepend("h,l")
        -- Ignore case when searching
        vim.opt.ignorecase = true
        -- When searching try to be smart about cases
        vim.opt.smartcase = true
        -- timeoutlen: timeout insert key
        vim.opt.timeoutlen = 300
        -- abilito il controllo ortografico
        -- vim.opt.spell = true
        -- Set English and Italian language
        vim.opt.spelllang = {"it", "en"}
        -- Cerca la documentazione in italiano se presente altrimenti in inglese
        vim.opt.helplang = {"it", "en"}
        -- Now, when using :sb, :sbnext, :sbprev instead of :b, :bnext, :bprev to switch buffers, Vim will check if buffer is open in tab/window and switch to that tab/window
        vim.opt.switchbuf = "usetab"
        -- di default era .,w,b,u,
        -- . => scan the current buffer ('wrapscan' is ignored)
        -- w => scan buffers from other windows
        -- b => scan other loaded buffers that are in the buffer list
        -- t => tag completion
        -- u => scan the unloaded buffers that are in the buffer list
        -- i => scan current and included files
        -- k => scan the files given with the 'dictionary'
        vim.opt.complete = {".","w","b","u"}
        -- every wrapped line will continue visually indented
        vim.opt.breakindent = true
        -- non fa vedere la tilde alla fine del file
        vim.opt.fillchars = { eob = " ", vert = "│" }
        -- vim.opt.fillchars = {
        --         eob = " "      ,
        --         horiz     = '━',
        --         horizup   = '┻',
        --         horizdown = '┳',
        --         vert      = '┃',
        --         vertleft  = '┫',
        --         vertright = '┣',
        --         verthoriz = '╋',
        --       }
        -- "▏" │" "▎" "⎸"" "¦" "┆" "" "┊"
        -- "▏" │" "▎" "⎸"" "¦" "┆" "" "┊"
        -- disabilito plugin caricati di default
        local disabled_built_ins = {
            "2html_plugin",
            "getscript",
            "getscriptPlugin",
            "gzip",
            "logipat",
            "netrw",
            "netrwPlugin",
            "netrwSettings",
            "netrwFileHandlers",
            "matchit",
            "matchparen",
            "man",
            "tar",
            "tarPlugin",
            "rrhelper",
            "spellfile_plugin",
            "vimball",
            "vimballPlugin",
            "zip",
            "zipPlugin",
            "loaded_less",
            "loaded_syntax_completion",
            "tutor_mode_plugin",
            "syntax_completion",
            "sql_completion",
            "rrhelper",
        }
        for _, plugin in pairs(disabled_built_ins) do
            vim.g["loaded_" .. plugin] = 1
        end

        -- sync with system clipboard
        vim.opt.clipboard = "unnamedplus"
        -- confirm to save changes before exiting modified buffer
        vim.opt.confirm = true
        vim.opt.grepprg = "rg --vimgrep"
        vim.opt.grepformat = "%f:%l:%c:%m"
        -- preview incremental substitute
        vim.opt.inccommand = "split"
        -- No double spaces with join after a dot
        vim.opt.joinspaces = false
        -- Lines of context
        vim.opt.scrolloff = 4
        -- Columns of context
        vim.opt.sidescrolloff = 8
        -- Round indent
        vim.opt.shiftround = true
        -- List of words that change the behavior of the |jumplist|
        vim.opt.jumpoptions = "stack"
        -- Time in milliseconds to wait for a key code sequence to complete
        vim.opt.ttimeoutlen = 10
        -- When "on" the commands listed below move the cursor to the first non-blank of the line.  When off the cursor is kept in the same column (if possible).
        vim.opt.startofline = true
        -- allows users to select what, if any, types of embedded script highlighting they wish to have.
        -- g:vimsyn_embed == 0      : disable (don't embed any scripts)
        -- g:vimsyn_embed == 'lPr'  : support embedded lua, python and ruby
        vim.g.vimsyn_embed = 'l'
        -- in modalità V-Block will only allow moving the cursor just after the last character of the line.
        vim.opt.virtualedit = "onemore"
        -- permette di cancellare in modo fluido attraverso indentazioni, fine riga e punto di inizio inserimento
        vim.opt.backspace = { "indent", "eol", "start" }
        -- consente di muovere il cursore oltre l'inizio e la fine delle righe usando i tasti freccia e di movimento
        vim.opt.whichwrap:append("<,>,[,]")

    --}}} Global

    --{{{ UI Setting
        vim.opt.shortmess = "IToOlxfitncWF"
        -- set the terminal's title
        vim.opt.title = true
        -- dont show mode since we have a statusline
        vim.opt.showmode = false
        -- set 5 lines to the cursor - when moving vertically using j/k
        vim.opt.so = 5
        -- Setta per ogni buffer l'opzione hidden di default, questo mi permette di passare in maniera più pratica tra i buffer(ved. usr_22: nascondere i buffer)
        vim.opt.hidden = true
        -- show line number
        vim.opt.number = true
        -- Command-line completion mode
        vim.opt.wildmode = "longest:full,full"
        -- file da ignorare nel wildmenu
        vim.opt.wildignore = {"*.o","*~","*.pyc","*.png","*.jpg","*.gif","*.xlsm","*.xls","*.xlsx","*.zip","*.so","*.exe","*.ico","*.lock","log/**","*\\log\\*","*/log/*","vendor/cache/**","vendor/rails/**","*\\tmp\\*","*/tmp/*","*/.git/*",".git",".git/*","*\\.git\\*","*/node_modules/**","*/node_modules_custom/**", ".bundle", ".yardoc", ".prettierrc"}
        -- Put new windows below current
        vim.opt.splitbelow = true
        -- Put new windows right of current
        vim.opt.splitright = true
        -- vim.opt.winheight = 10
        -- vim.opt.winminheight = 4
        -- vim.opt.winwidth = 40
        -- vim.opt.winminwidth = 18
        -- setto la trasparenza del pum
        vim.opt.pumblend = 10
        -- setto la trasparenza dell preview window
        vim.opt.winblend = 5
        -- Maximum number of entries in a popup
        vim.opt.pumheight = 10
        -- Always show the signcolumn, se metto "number" al posto di "yes" mostra i sign nella colonna dei numer
        vim.opt.signcolumn = "yes"
    --}}} UI Setting

    --{{{ Increase Perfomance
        -- migliora le performance di neovim
        cmd([[syntax sync maxlines=3000]])
        cmd([[syntax sync minlines=10]])
        vim.opt.cursorcolumn = false
        vim.opt.cursorline = false
        vim.opt.synmaxcol = 2500
        -- Don't redraw while executing macros (good performance config)
        vim.opt.lazyredraw = true
        vim.opt.ruler = false
        vim.opt.showcmd = false
        -- Time in milliseconds for redrawing the display
        vim.opt.redrawtime = 1500
    --}}} Increase Perfomance

    --{{{ Files, backups and undo, Save
        -- Turn backup off
        vim.opt.writebackup = false
        vim.opt.swapfile = false
        -- Persistent undo
        vim.opt.undofile = true
        vim.opt.undolevels = 200
        vim.opt.sessionoptions = {
            "buffers",     -- Buffer nascosti
            "curdir",      -- Directory di lavoro corrente
            "folds",       -- Stato delle fold
            "globals",     -- Variabili globali (iniziano con maiuscola)
            "help",        -- Finestre della guida
            "localoptions",-- Opzioni locali di buffer e finestre
            "options",     -- Opzioni globali
            "resize",      -- Dimensioni delle finestre
            "tabpages",    -- Tab pages
            "terminal",    -- Terminali
            "winpos",      -- Posizione finestra Vim
            "winsize",     -- Dimensione finestra
            "slash",       -- Backslashes in nomi file
            "unix",        -- File endings
        }
        -- vim.opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "resize", "winpos", "terminal" }
    --}}} Files, backups and undo

    --{{{ Tab and indent
        -- Use spaces instead of tabs
        vim.opt.expandtab = true
        -- 1 tab == 2 spaces
        -- vim.opt.shiftwidth = 2
        -- vim.opt.tabstop = 2
        -- vim.opt.softtabstop = 2
        -- Line break on 500 characters
        vim.opt.linebreak = true
        -- Insert indents automatically
        vim.opt.smartindent = true
        -- Disable line wrap
        vim.opt.wrap = false
    --}}} Tab and indent

    --{{{ Folding
        -- deepest fold is 10 levels
        vim.opt.foldnestmax = 10
        -- cosa viene visualizzato quando faccio il folding del codice
        -- vim.opt.foldtext = "v:lua.custom_fold_text()"
        -- rimuove i caratteri ----- dopo il fold
        vim.opt.fillchars =  "fold: "
        -- fare l'unfold automatico
        -- TODO: vedere se serve lasciarlo o toglierlo
        vim.opt.foldopen:append('insert')
        -- setto il default foldlevel quando apro un file
        -- TODO: vedere se serve lasciarlo o toglierlo
        vim.opt.foldlevel = 1
        vim.opt.foldexpr = "v:lua.require'sphynx.utils.folding'.foldexpr()"
        vim.opt.foldmethod = "expr"
    --}}} Folding

    --{{{ Visualizzazione
        -- Hide * markup for bold and italic
        vim.opt.conceallevel = 2
        -- Hide * markup for bold and italic
        vim.opt.concealcursor = "n"
        -- Show some invisible characters (tabs...
        -- TODO: vedere se lasciarlo
        vim.opt.list = true
        -- vim.opt.listchars = {eol = '↲', tab = '▸ ', trail = '·', space = "."}
    --}}} Visualizzazione

--}}} General

--{{{ Markdown
  -- Use proper syntax highlighting in code blocks
  local fences = {
    "lua",
    -- "vim",
    "json",
    "typescript",
    "javascript",
    "js=javascript",
    "ts=typescript",
    "shell=sh",
    "python",
    "sh",
    "console=sh",
    "go",
    "ruby",
    "html",
  }
  vim.g.markdown_fenced_languages = fences

  -- plasticboy/vim-markdown
  vim.g.vim_markdown_folding_level = 10
  vim.g.vim_markdown_fenced_languages = fences
  vim.g.vim_markdown_folding_style_pythonic = 1
  vim.g.vim_markdown_conceal_code_blocks = 0
  vim.g.vim_markdown_folding_style_pythonic = 1
  vim.g.vim_markdown_frontmatter = 1
  vim.g.vim_markdown_strikethrough = 1
--}}} Markdown

--{{{ Abbreviation
    cmd([[ab todo # @TODO:]])
    cmd([[ab <silent> bp binding.pry<C-o>]])
    cmd([[cnoreabbrev LS LspStart]])
    cmd([[cnoreabbrev LAS Lazy show]])
    cmd([[cnoreabbrev LAC Lazy check]])
    cmd([[cnoreabbrev LAU Lazy update]])
--}}} Abbreviation

--{{{ Nvim Provider

    --{{{ Node
        -- vim.g.node_host_prog = "C:/Program Files/nodejs/node_modules/neovim/bin/cli.js"
    --}}} Node

    --{{{ Python2
        vim.g.loaded_python_provider = 0
    --}}} Python2

    --{{{ Python3
        -- vim.g.loaded_python3_provider = 0
        if not (vim.g.loaded_python3_provider) then
            local python3_host_prog = vim.fn.expand('C:/APPL/Python/python')
            if (vim.fn.filereadable(vim.fn.fnameescape(python3_host_prog .. ".exe"))) == 1 then
                vim.g.python3_host_prog = vim.fn.fnameescape(python3_host_prog)
                vim.opt.pyxversion = 3
            else
                local msg = "\'Devi installare python3!\'"
                if vim.g.loaded_python3_provider then
                    vim.g.nvim_del_var("python3_host_prog")
                end
                cmd('echohl WarningMsg | echomsg "=> "' .. msg .. '| echohl None')
            end
        end
    --}}} Python3

    --{{{ Ruby
        vim.g.loaded_ruby_provider = 0
        if not (vim.g.loaded_ruby_provider) then
            local ruby_host_prog = vim.fn.expand('C:/Ruby3/bin/neovim-ruby-host')
            if (vim.fn.filereadable(vim.fn.fnameescape(ruby_host_prog))) == 1 then
                vim.g.ruby_host_prog = vim.fn.fnameescape(ruby_host_prog)
            else
                local msg = "\'Gemma neovim non installata!\'"
                if vim.g.ruby_host_prog then
                    vim.g.nvim_del_var("ruby_host_prog")
                end
                cmd('echohl WarningMsg | echomsg "=> "' .. msg .. '| echohl None')
            end
        end
    --}}} Ruby

    --{{{ Perl
        vim.g.loaded_perl_provider = 0
    --}}} Perl

--}}} Nvim Provider

--{{{ Other Gui

    if vim.g.nvui then
      -- Configure through vim commands
      vim.opt.guifont = "DejaVuSansM Nerd Font:h10:cANSI:qDRAFT"
      -- vim.opt.guifont = "CaskaydiaCove NF:h10:cANSI:qDRAFT"
      cmd [[NvuiFrameless v:true]]
      cmd [[NvuiCursorAnimationDuration 0.08]]
      cmd [[NvuiSnapshotLimit 6]]
      cmd [[NvuiCmdCenterYPos 0.5]]
      cmd [[NvuiCmdTopPos 0.5]]
      cmd [[NvuiCmdFontSize 12]]
      cmd [[NvuiCmdBigFontScaleFactor 1]]
    end

    if vim.g.nvy then
        -- vim.opt.guifont = "DejaVuSansM Nerd Font:h9:cANSI:qDraft"
        vim.opt.guifont = "FiraCode Nerd Font:h9:cANSI:qDraft"
        -- vim.opt.guifont = "JetBrainsMonoNL Nerd Font Mono:h9:cANSI:qDraft"
        -- vim.opt.guifont = "JetBrainsMono Nerd Font:h9:cANSI:qDraft"
        -- vim.opt.guifont = "MonaspiceNE Nerd Font:h9:cANSI:qDRAFT"
    end

    if vim.g.neovide then
        vim.opt.guifont = "DejaVuSansM Nerd Font:h9:cANSI:qDRAFT"
        -- vim.opt.guifont = "MonaspiceNE Nerd Font:h9"
        vim.opt.linespace = -1
        vim.g.neovide_scroll_animation_length = 0
        vim.g.neovide_refresh_rate = 120
        vim.g.neovide_cursor_antialiasing = true
        vim.g.neovide_cursor_animation_length = 0
        vim.g.neovide_cursor_animate_in_insert_mode = false
        vim.g.neovide_cursor_animate_command_line = false
        vim.g.neovide_cursor_vfx_mode = ""
        vim.g.neovide_unlink_border_highlights = true
        cmd("imap <M-Esc> [")
        cmd("imap <M-C-]> ]")
        -- Helper function for transparency formatting
        -- local alpha = function()
        --   return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
        -- end
        -- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
        -- vim.g.neovide_transparency = 0
        -- vim.g.transparency = 1
        -- vim.g.neovide_background_color = "#0f1117" .. alpha()
    end

    if vim.g.gonvim_running then
        vim.opt.ruler = false
        vim.opt.laststatus = 0
        vim.opt.showcmd = false
    end
--}}} Other Gui

--{{{ Test
    -- This is a sequence of letters which describes how automatic formatting is to be done
    -- TAG:[#comment #format] Ho disabilitato che mi crea la riga commentata automaticamente, se viglio aggiungerla devo aggiungere la "o"
    vim.opt.formatoptions = "1jcrql"
    -- Virtual editing means that the cursor can be positioned where there is no actual character.
    vim.opt.virtualedit = "block"
    -- VimL support fold autogroup and function
    vim.g.vimsyn_folding  = 'af'


    vim.opt.cmdheight = 0

    vim.opt.splitkeep = "screen"

    vim.g.editorconfig = false

    vim.opt.smoothscroll = true

    -- uso il plugin Filetype.nvim per velocizzare avvio @perfermance
    -- vim.g.did_load_filetypes = 1
--}}} Test

-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
-- vim.opt.foldmethod = "expr" -- TreeSitter folding
-- vim.cmd([[let g:prosession_last_session_dir = $HOME . '/.dotfiles/vimfiles/session_nvim']])
-- vim.cmd([[let g:prosession_dir = $HOME . '/.dotfiles/vimfiles/session_nvim']])
-- vim.cmd([[:let g:prosession_dir = 'C:\Users\en27553\.vim\session\']])

-- salvataggio automatico dei file
-- vim.cmd([[autocmd WinLeave,FocusLost  *
--             \   if &ft!=""
--             \   && &ft!="nerdtree"
--             \   && &ft!="qf"
--             \   && &ft!="vim-plug"
--             \   && !&readonly
--             \   && (filereadable(expand('%')) == 1)
--             \ | silent write
--             \ | endif]])

