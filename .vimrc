" Colors -------------------------------------
colorscheme vividchalk "install color scheme
syntax enable

" Misc ---------------------------------------

" Spaces & Tabs ------------------------------
set tabstop=4
set softtabstop=4 " number of spaces in tab
set expandtab " tabs are spaces

" UI Layout ----------------------------------
set number
set cursorline
filetype indent on
set wildmenu " visual autocomplete for command menu
set showmatch " match parenthesis and brackets

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

" NERDTree -----------------------------------

" Syntastic ----------------------------------

" Launch Config ------------------------------

" Backups ------------------------------------
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=.,$TEMP
set writebackup

