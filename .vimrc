"===============================
" General Settings
"===============================
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,!

"===============================
" Files, backups and undo
"===============================
set nobackup
set nowb
set noswapfile
set hidden
set nocompatible
set autoread
set updatetime=0

"===============================
" Search
"===============================
set incsearch
set smartcase
set hlsearch

set wildmenu
set wildmode=longest:full,full

"===============================
" Text, tab and indent
"===============================
set softtabstop=4
set autoindent
set smartindent
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set lbr
set tw=500
set ai
set si
set wrap

"===============================
" Clipboard and paste
"===============================
set clipboard^=unnamedplus

"===============================
" Mouse Scroll and Display
"===============================
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set number
set cursorline
set scrolloff=8
set sidescrolloff=16
set sidescroll=1
set showcmd
set colorcolumn=80
syntax enable

"===============================
" CursorLine and Line Number Styling
"===============================
highlight CursorLine ctermbg=236 guibg=#2C2C2C
highlight LineNr ctermbg=235 guibg=#3C3C3C ctermfg=gray guifg=#AAAAAA
highlight CursorLineNr ctermbg=236 guibg=#505050 ctermfg=white guifg=#FFFFFF

"===============================
" Command Line & Status Line Styling
"===============================
highlight StatusLine ctermbg=237 guibg=#444444 ctermfg=white guifg=#FFFFFF
highlight StatusLineNC ctermbg=235 guibg=#303030 ctermfg=gray guifg=#AAAAAA
highlight CmdLine ctermbg=238 guibg=#3A3A3A ctermfg=white guifg=#FFFFFF

"===============================
" Window Split Styling
"===============================
highlight VertSplit ctermbg=236 guibg=#2E2E2E ctermfg=gray guifg=#888888


