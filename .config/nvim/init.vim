""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .init.vim
"                                            for neovim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > General Setting

" Encode
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

" Disable beep
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Files, backups and undo

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
set hidden
set nocompatible
set autoread
set updatetime=0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Search

set incsearch
set smartcase
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Text, tab and indent related

set softtabstop=4
set autoindent
set smartindent

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

set paste

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Mouse Scroll

set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set number
set cursorline
set scrolloff=8
set sidescrolloff=16
set sidescroll=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > dein

if (!isdirectory(expand("$HOME/.cache/nvim/repos/github.com/Shougo/dein.vim")))
  call system(expand("mkdir -p $HOME/.cache/nvim/repos/github.com"))
  call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.cache/nvim/repos/github.com/Shougo/dein.vim"))
endif

set runtimepath+=~/.cache/nvim/repos/github.com/Shougo/dein.vim/

call dein#begin(expand('~/.cache/nvim'))
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#add('Shougo/deoplete.nvim')
call dein#add('zchee/deoplete-jedi')
call dein#add('flazz/vim-colorschemes')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('Yggdroot/indentLine')
call dein#add('tomtom/tcomment_vim')
call dein#add('vim-syntastic/syntastic')
call dein#add('scrooloose/nerdtree')
call dein#add('junegunn/fzf', { 'build': './install', 'merged': 0 })
call dein#end()
call dein#save_state()

if dein#check_install()
  call dein#install()
endif

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:python3_host_prog = expand('/usr/local/bin/python3')

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

inoremap <expr><C-g> deoplete#undo_completion()
" <C-l>: redraw candidates
inoremap <expr><C-l>       deoplete#refresh()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#cancel_popup() . "\<CR>"
endfunction

inoremap <expr> '  pumvisible() ? deoplete#close_popup() : "'"

" call deoplete#custom#set('_', 'matchers', ['matcher_head'])
call deoplete#custom#set('ghc', 'sorters', ['sorter_word'])
" call deoplete#custom#set('buffer', 'mark', '')
" call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
" call deoplete#custom#set('_', 'disabled_syntaxes', ['Comment', 'String'])
" call deoplete#custom#set('buffer', 'mark', '*')

" Use auto delimiter
" call deoplete#custom#set('_', 'converters',
"       \ ['converter_auto_paren',
"       \  'converter_auto_delimiter', 'remove_overlap'])
call deoplete#custom#set('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_menu',
      \ 'converter_auto_delimiter',
      \ ])

" call deoplete#custom#set('buffer', 'min_pattern_length', 9999)
call deoplete#custom#set('clang', 'input_pattern', '\.\w*|\.->\w*|\w+::\w*')
call deoplete#custom#set('clang', 'max_pattern_length', -1)

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'
" let g:deoplete#keyword_patterns.tex = '\\?[a-zA-Z_]\w*'
let g:deoplete#keyword_patterns.tex = '[^\w|\s][a-zA-Z_]\w*'

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.python = ''
let g:deoplete#omni#functions = {}

" inoremap <silent><expr> <C-t> deoplete#manual_complete('file')

let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_camel_case = 1
" let g:deoplete#auto_complete_delay = 50
" let g:deoplete#auto_complete_start_length = 3

let g:deoplete#skip_chars = ['(', ')']

" airline settings
set laststatus=2
set showmode
set showcmd
set ruler

 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " = > colorscheme

filetype plugin indent on
set background=dark
let g:airline_theme='base16'
colorscheme gruvbox
syntax enable
