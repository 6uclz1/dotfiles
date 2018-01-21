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

set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Files, backups and undo

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
set hidden
set autoread
set updatetime=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Search

set incsearch
set smartcase
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Text, tab and indent related

" Use spaces instead of tabs
set expandtab

" 1 tab == 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" Be smart when using tabs ;)
set smarttab

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

" git sync dotfiles >>> ~/.config/nvim/*
" download plugins  >>> ~/.cache/nvim/dein

if (!isdirectory(expand("$HOME/.cache/nvim/dein/repos/github.com/Shougo/dein.vim")))
  call system(expand("mkdir -p $HOME/.cache/nvim/dein/repos/github.com"))
  call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.cache/nvim/dein/repos/github.com/Shougo/dein.vim"))
endif

set runtimepath+=~/.cache/nvim/dein/repos/github.com/Shougo/dein.vim/

call dein#begin(expand('~/.cache/nvim/dein'))
let s:toml = expand('~/.config/nvim/dein.toml')
let s:lazy_toml = expand('~/.config/nvim/dein_lazy.toml')
call dein#load_toml(s:toml, {'lazy': 0})
call dein#load_toml(s:lazy_toml, {'lazy': 1})
call dein#end()
call dein#save_state()

" Required
filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

" vim-indent-guide setting
let g:indent_guides_enable_on_vim_startuc = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

" airline settings
set laststatus=2
set showmode
set showcmd
set ruler

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

let g:quickrun_no_default_key_mappings = 1
nmap <Leader>r :cclose<CR>:write<CR>:QuickRun -mode n<CR>

" ale
let g:ale_sign_error = '⨉'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_column_always = 1

let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0

let g:ale_linters = {
\   'python': ['flake8'],
\}

let g:ale_emit_conflict_warnings = 0

nmap [ale] <Nop>
map <C-k> [ale]
nmap <silent> [ale]<C-P> <Plug>(ale_previous)
nmap <silent> [ale]<C-N> <Plug>(ale_next)

let g:pymode_indent = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > colorscheme

set background=dark
let g:airline_theme='base16'
colorscheme gruvbox
syntax enable
