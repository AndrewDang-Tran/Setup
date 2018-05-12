" Setup vim plugin manager ------------------
call plug#begin('~/.vim/plugged')

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

call plug#end()

" Colors -------------------------------------
set t_Co=256
syntax enable
colorscheme OceanicNext "install color scheme

" Misc ---------------------------------------

" Spaces & Tabs ------------------------------
set tabstop=4
set softtabstop=4 " number of spaces in tab
set expandtab " tabs are spaces
set shiftwidth=4 
set list lcs=eol:¬,trail:·,tab:▸\ 
autocmd FileType php setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.twig set syntax=html
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType js setlocal shiftwidth=2 tabstop=2 softtabstop=2

" UI Layout ----------------------------------
set number
set cursorline
filetype plugin indent on
set wildmenu " visual autocomplete for command menu
set showmatch " match parenthesis and brackets
set history=50 " keep 50 lines of cmd line history
set ruler " show cursor at all times
set showcmd " display incomplete commands

" PHP Options --------------------------------
"let g:php_syntax_extensions_enabled = 1
"let b:php_syntax_extensions_enabled = 1

" Searching ----------------------------------
set incsearch "search as characters are entered
set hlsearch

" Folding ------------------------------------
set foldenable
set foldlevelstart=10 " opens most folds depending on line size
set foldmethod=indent " fold based on indents

" Movement -----------------------------------
"  move through lines visually
nnoremap j gj 
nnoremap k gk

" Line Shortcuts -----------------------------

" Leader Shortcuts ---------------------------
cmap w!! w !sudo tee > /dev/null %

" Powerline ----------------------------------

" CtrlP --------------------------------------
let mapleader=" "
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

" NERDTree -----------------------------------

" Syntastic ----------------------------------

" Launch Config ------------------------------
execute pathogen#infect()

" Backups ------------------------------------
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=.,$TEMP
set writebackup

