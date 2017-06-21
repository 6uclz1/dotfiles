""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
scriptencoding utf-8

set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,!

set expandtab
set softtabstop=4
set autoindent
set smartindent
set number

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > General Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable beep
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
set hidden
set nocompatible
set autoread
set updatetime=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set clipboard=unnamed
set clipboard=autoselect

set paste

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Mouse Scroll
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescrolloff=16
set sidescroll=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > dein
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)
	call dein#add('Shougo/dein.vim')
	call dein#add('Shougo/vimproc.vim', {'build': 'make'})
	call dein#add('Shougo/neocomplete.vim')
	call dein#add('Shougo/neomru.vim')
	call dein#add('Shougo/neosnippet')
	call dein#add('w0ng/vim-hybrid')
	call dein#add('flazz/vim-colorschemes')
	call dein#add('itchyny/lightline.vim')
	call dein#add('bronson/vim-trailing-whitespace')
	call dein#add('ctrlpvim/ctrlp.vim')
	call dein#add('Yggdroot/indentLine')
	call dein#add('tomtom/tcomment_vim')
	call dein#add('vim-syntastic/syntastic')
	call dein#add('scrooloose/nerdtree')
	call dein#add('junegunn/fzf', { 'build': './install', 'merged': 0 })
call dein#end()
endif

if dein#check_install()
  call dein#install()
endif

set laststatus=2
set showmode
set showcmd
set ruler

 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " = > colorscheme
 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on

set background=dark
colorscheme gruvbox
syntax enable
