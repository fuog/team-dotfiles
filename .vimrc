" enter the current millenium
set nocompatible

"""""""""""""""""""""""""""""""""""""
" UI
"""""""""""""""""""""""""""""""""""""
" show line numbers
set number

" show courser line
set cursorline

" show cursor column -- looks like this makes things slower
set cursorcolumn

" simulate a linebreak if line gets too long
set wrap

" Disable vim automatic visual mode on mouse select
" https://gist.github.com/u0d7i/01f78999feff1e2a8361
set mouse-=a

" try to use the solarized colorscheme
syntax enable
" set background=dark " unsure if needed
silent! colorscheme foo

" Display all matching files when we tab complete
set wildmenu

"""""""""""""""""""""""""""""""""""""
" Indents
"""""""""""""""""""""""""""""""""""""
" replace tabs with spaces
set expandtab
" 1 tab = 2 spaces
set tabstop=2 shiftwidth=2

" when deleting whitespace at the beginning of a line, delete
" 1 tab worth of spaces (for us this is 2 spaces)
set smarttab

" when creating a new line, copy the indentation from the line above
set autoindent


"""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""
" Ignore case when searching
set ignorecase
set smartcase

" highlight search results (after pressing Enter)
set hlsearch

" highlight all pattern matches WHILE typing the pattern
set incsearch

" show the mathing brackets
set showmatch

" highlight current line
set cursorline

"""""""""""""""""""""""""""""""""""""
" Mix
"""""""""""""""""""""""""""""""""""""
" :W sudo saves the file when the file is open in readonly mode
command W w !sudo tee % > /dev/null

" Return vim to the last known position
augroup line_return
    au!
    au BufreadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   execute "normal! g'\"" |
                \ endif

" do not use swapfiles
set noswapfile

" let me turn inset mode on/off with F2
set pastetoggle=<F2>


