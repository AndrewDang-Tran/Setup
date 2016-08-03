" Colors -------------------------------------
colorscheme vividchalk "install color scheme
syntax enable

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

" UI Layout ----------------------------------
set number
set cursorline
filetype plugin indent on
set wildmenu " visual autocomplete for command menu
set showmatch " match parenthesis and brackets
set history=50 " keep 50 lines of cmd line history
set ruler " show cursor at all times
set showcmd " display incomplete commands
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
      syntax on
        set hlsearch
    endif

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

" Powerline ----------------------------------

" CtrlP --------------------------------------
let mapleader=" "
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p

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

