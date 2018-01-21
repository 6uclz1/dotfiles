""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc

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

" :e <TAB> seems good :)
set wildmenu wildmode=list:full

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Clipboard and paste

set clipboard&
set clipboard^=unnamedplus
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
" = > Custom Keymap

" <C-i> Run Script
nnoremap <C-i> :!python %

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Language Settings

" Python

let g:pymode_python = 'python3'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > dein

let s:dein_dir = expand('~/.cache/vim/dein')
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
	call dein#add('bronson/vim-trailing-whitespace')
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('ctrlpvim/ctrlp.vim')
	call dein#add('Yggdroot/indentLine')
	call dein#add('tomtom/tcomment_vim')
	call dein#add('vim-syntastic/syntastic')
	call dein#add('Vimjas/vim-python-pep8-indent')
	call dein#add('scrooloose/nerdtree')
	call dein#add('junegunn/fzf', { 'build': './install', 'merged': 0 })
  call dein#add('mileszs/ack.vim')
  call dein#add('thinca/vim-quickrun')
  call dein#add('w0rp/ale')
call dein#end()
endif

if dein#check_install()
  call dein#install()
endif

" airline settings
set laststatus=2
set showmode
set showcmd
set ruler

" fzf settings
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" ag settings
let g:ackprg = 'ag --nogroup --nocolor --column'

" PyFlake
let g:PyFlakeOnWrite = 1
let g:PyFlakeCheckers = 'pep8,mccabe,pyflakes'
let g:PyFlakeDefaultComplexity=10

" QuickRun
let g:quickrun_config = {
    \ '_' : {
        \ 'runner' : 'vimproc',
        \ 'runner/vimproc/updatetime' : 40,
        \ 'outputter' : 'error',
        \ 'outputter/error/success' : 'buffer',
        \ 'outputter/error/error'   : 'quickfix',
        \ 'outputter/buffer/split' : ':botright 8sp',
    \ }
\}

" 実行時に前回の表示内容をクローズ&保存してから実行
let g:quickrun_no_default_key_mappings = 1
nmap <Leader>r :cclose<CR>:write<CR>:QuickRun -mode n<CR>

 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 " = > colorscheme

filetype plugin indent on

colorscheme gruvbox
let g:airline_theme='base16'
set background=dark
syntax enable
