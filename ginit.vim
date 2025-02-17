let g:is_nvim_qt = exists('g:GuiLoaded')
let g:is_gvim = has('gui_running')

if g:is_nvim_qt
  " :Guifont! Hack NF:h10:cANSI:qDraft
  " Guifont! InconsolataGo NF:h12:cANSI:qDraft
  " Guifont! FuraCode NF:h10:cANSI:qDraft
  " :Guifont! DejaVuSansMonoForPowerLine Nerd:h10:cANSI:qDraft
  :Guifont! DejaVuSansMono NF:h10:cANSI:qDraft
  " GuiLinespace 0.8
  " GuiScrollBar 1
        GuiTabline 0
  GuiPopupmenu 0
   call GuiWindowMaximized(1)
  "Guifont! Delugia Nerd Font:h10:cANSI:qDraft
  "set guifont=Delugia\ Nerd\ Font:h13:cANSI:qDRAFT

  " colorscheme nord
  " set background=dark
  " colorscheme OceanicNext
  " colorscheme onedark
  " let ayucolor="light"  " for light version of theme
  " let ayucolor="mirage" " for mirage version of theme
elseif g:is_gvim
  if WINDOWS()
    " set guifont=Sauce_Code_Powerline:h8      " Font family and font size.
    " :set guifont=knack:h8:qDRAFT
    " set guifont=DejaVuSansMonoForPowerLine_Nerd:h10:cANSI:qDRAFT
    " :set guifont=FuraCode_NF:h9:cANSI:qDRAFT
    " set guifont=Delugia\ Nerd\ Font:h10:cANSI:qDRAFT
    set guifont=DejaVuSansMono\ NF:h10:cANSI:qDRAFT
    set linespace=0
    " set guifont=UbuntuMonoDerivativePowerline_N:h12:cANSI:qDRAFT
  elseif OSX()
    " Font family and font size
    set guifont=Source\ Code\ Pro\ for\ Powerline:h11
    " Macvim smooth fonts
    set antialias 
  endif

  set background=dark               " Background.
  set cmdheight=1
  set mouse=a
  set nomousefocus
  set mousehide
  set guioptions-=e
  " hide toolbar
  set guioptions-=T
  " hide menubar
  set guioptions-=m
  set guioptions+=M
  " hide the left-hand scrollbar for splits/new windows
  set guioptions-=L
  " hide the right scrollbar
  set guioptions-=r
else
  echom "No Gui Running"
endif 


" if exists('g:fvim_loaded')
"     " good old 'set guifont' compatibility
"     set guifont=Delugia\ Nerd\ Font:h14
"     " Ctrl-ScrollWheel for zooming in/out
"     nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
"     nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
"     nnoremap <A-CR> :FVimToggleFullScreen<CR>
"     FVimCursorSmoothMove v:true
"     FVimCursorSmoothBlink v:true
" endif

" if exists('g:fvim_loaded')
"   set termguicolors
"   colorscheme gruvbox8_hard
"   set guifont=Hack:h13
"   " Cursor tweaks
"   FVimCursorSmoothMove v:true
"   FVimCursorSmoothBlink v:true

"   " Background composition, can be 'none', 'blur' or 'acrylic'
"   FVimBackgroundComposition 'none'
"   FVimBackgroundOpacity 1.0
"   FVimBackgroundAltOpacity 1.0

"   " Title bar tweaks (themed with colorscheme)
"   FVimCustomTitleBar v:true

"   " Debug UI overlay
"   FVimDrawFPS v:false
"   " Font debugging -- draw bounds around each glyph
"   FVimFontDrawBounds v:false

"   " Font tweaks
"   FVimFontAntialias v:true
"   FVimFontAutohint v:true
"   FVimFontHintLevel 'full'
"   FVimFontSubpixel v:true
"   FVimFontLigature v:true
"   " can be 'default', '14.0', '-1.0' etc.
"   FVimFontLineHeight '+1'

"   " Try to snap the fonts to the pixels, reduces blur
"   " in some situations (e.g. 100% DPI).
"   FVimFontAutoSnap v:true

"   " Font weight tuning, possible values are 100..900
"   FVimFontNormalWeight 100
"   FVimFontBoldWeight 700

"   FVimUIPopupMenu v:false
" endif

