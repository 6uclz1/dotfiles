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
" => General Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable beep
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
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
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

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
" => Mouse Scroll
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescrolloff=16
set sidescroll=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NeoBundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/

    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
"" vim plugins
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'Yggdroot/indentLine'

set laststatus=2
set showmode
set showcmd
set ruler

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

set background=dark
colorscheme hybrid
syntax on

