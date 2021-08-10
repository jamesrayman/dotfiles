" TODO:
" Language features
" Spell check
" config files (e.g. comment styles, dictionaries, etc)
" Separate large features into plugins
" Vim in terminal


""" Plugin setup
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo ' . data_dir . 
        \ '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'sainnhe/sonokai'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-lastpat'
Plug 'sgur/vim-textobj-parameter'
Plug 'thinca/vim-textobj-between'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'airblade/vim-gitgutter'
call plug#end()
filetype plugin on

""" Leader
let mapleader=" "

""" NERDTree
nnoremap <expr> <silent> <C-n> bufname() =~# 'NERD_tree_\d\+' ? "\<C-w>p" : ":NERDTreeFocus\<CR>"
nnoremap <silent> <leader>r :NERDTreeRefreshRoot<CR>
nnoremap <silent> <leader>n :NERDTreeFind<CR>

" Close tab if NERDTree is the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~# 'NERD_tree_\d\+' && bufname('%') !~# 'NERD_tree_\d\+' && winnr('$') > 1 | 
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer' . buf | endif

" Don't put the signcolumn on NERDTree
autocmd BufEnter * if bufname('#') =~# 'NERD_tree_\d\+' | setlocal signcolumn=no | endif

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | setlocal signcolumn=no | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

" UI Changes
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=1

""" NERDCommenter
vmap <C-_> <plug>NERDCommenterToggle
nmap <C-_> <plug>NERDCommenterToggle
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1
let g:NERDCreateDefaultMappings=0
lef g:NERDCustomDelimiters={'python': {'left': '#', 'right': ''}}


""" Misc settings
syntax enable
set nocompatible
set encoding=utf-8
set showcmd
set wildmenu
set wildmode=list:full,full
set lazyredraw
set ruler
set title
set complete-=i
set confirm
set nomodeline
set display+=lastline
set dir=~/.vim/swap
set hidden
set updatetime=1000
set nojoinspaces

""" Formatting options
set fo=jcrqln

""" Editor rule and line wrapping
set wrap linebreak nolist
set colorcolumn=121
set textwidth=72

""" Tabs and windows
set winminheight=0
set winminwidth=0
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

""" Indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set shiftround

""" Searching
set incsearch
set nohlsearch
set ignorecase
set smartcase
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

""" Line numbering
set number
set relativenumber
set signcolumn=yes

" More intuitive Y
nnoremap Y y$

" Insert mode paste shortcut
inoremap <C-y> <C-r>+

" Other shortcuts
nnoremap gl $
nnoremap gL ^
nnoremap Z= 1z=

" Backspace switches to the alternate file
nnoremap <expr> <silent> <BS> bufname() == "terminal" ? "" : "\<C-^>"

" Up and down arrow keys scroll
noremap <silent> <Up> @="10gk10\<lt>C-y>"<CR>
noremap <silent> <Down> @="10gj10\<lt>C-e>"<CR>

" Right arrow key changes windows
noremap <Right><Up> <C-w>k
noremap <Right><Down> <C-w>j
noremap <Right><Left> <C-w>h
noremap <Right><Right> <C-w>l

" Left arrow key for tabs and page top/bottom
noremap <Left><Up> gg
noremap <Left><Down> G
noremap <Left><Left> gT
noremap <Left><Right> gt


" Zen mode
nnoremap <leader>z :tab sp<CR>

" Wrap a paragraph
nnoremap <leader>w gwap

" Substitute
nnoremap <leader>/ :%s/
vnoremap <leader>/ :s/


""" Scrolling
nnoremap <silent> <C-u> @="10gk10\<lt>C-y>"<CR>
nnoremap <silent> <C-d> @="10gj10\<lt>C-e>"<CR>
set scrolloff=2
set sidescrolloff=5


""" Shell
set shell=/usr/bin/env\ VMUX=a\ bash\ -l

""" Color theming
set t_Co=256
colorscheme sonokai
set cursorline
highlight SpecialKey ctermfg=201
highlight NonText ctermfg=201

""" Undo file
if !empty(glob(data_dir . '/.vim/undo'))
    silent execute '!mkdir ' . data_dir . '/.vim/undo'
endif
set undofile
set undodir=~/.vim/undo

""" Terminal focus
function! MakeTerminalWindow()
    sp
    wincmd j
    resize 15
    term
    setlocal signcolumn=no
    setlocal wrap
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber
    setlocal winfixheight
    f terminal
endfunction

function! ToggleTerminal()
    let index = bufwinnr('terminal')
    if index == -1
        let index = bufnr('terminal')
        if index == -1
            call MakeTerminalWindow()
        else
            below sb terminal
            resize 15
        endif
        norm i
    elseif bufname() == 'terminal'
        q
    else
        exec index . "wincmd w"
        norm i
    endif
endfunction

command ToggleTerminal call ToggleTerminal()

nnoremap <silent> <M-`>; :ToggleTerminal<CR>
tnoremap <silent> <M-`>; <C-\><C-n>
inoremap <M-`>; <Esc>:ToggleTerminal<CR>

""" Folding
set foldmethod=indent
set nofoldenable

""" Spell check
set spell
set spelllang=en_us
set spellfile=~/.vim/spell/en.utf-8.add

""" Diff

" Diff should inherit wrap
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

set diffopt=internal,filler,algorithm:patience,indent-heuristic,vertical

" :D[iff]r[egs] a b should do a diff check of registers a and b in a new tab

" Modified text operators
xnoremap <silent> im :<C-u> normal! `[v`]<CR>
onoremap <silent> im : normal vim<CR>
xnoremap <silent> am :<C-u> normal! `[v`]<CR>
onoremap <silent> am : normal vam<CR>

""" Language specific

set matchpairs+=<:>
set indentkeys-=:

call textobj#user#plugin('latex', {
\   'environment': {
\     '*pattern*': ['\\begin{[^}]\+}.*\n\s*', '\n^\s*\\end{[^}]\+}.*$'],
\     'select-a': 'aE',
\     'select-i': 'iE',
\   },
\  'bracket-math': {
\     '*pattern*': ['\\\[', '\\\]'],
\     'select-a': 'a\b',
\     'select-i': 'i\[',
\   },
\  'paren-math': {
\     '*pattern*': ['\\(', '\\)'],
\     'select-a': 'a\(',
\     'select-i': 'i\(',
\   },
\  'dollar-math-a': {
\     '*pattern*': '[$][^$]*[$]',
\     'select': 'a$',
\   },
\  'dollar-math-i': {
\     '*pattern*': '[$]\zs[^$]*\ze[$]',
\     'select': 'i$',
\   },
\  'quote': {
\     '*pattern*': ['`', "'"],
\     'select-a': 'aq',
\     'select-i': 'iq',
\   },
\  'double-quote': {
\     '*pattern*': ['``', "''"],
\     'select-a': 'aQ',
\     'select-i': 'iQ',
\   },
\ })



" g/ should search current selection/word under cursor without moving cursor
" g? should act similarly
