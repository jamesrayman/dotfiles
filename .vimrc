" TODO:
" Language features
" config files (e.g. comment styles, dictionaries, etc)
" Separate large features into plugins


""" Plugin setup
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo ' . data_dir . 
        \ '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'sainnhe/sonokai'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-lastpat'
Plug 'sgur/vim-textobj-parameter'
Plug 'thinca/vim-textobj-between'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()
filetype plugin on


""" Make directories
for s:dir in ['/undo', '/spell', '/swap']
    if empty(glob(data_dir . s:dir))
        silent execute '!mkdir -p ' . data_dir . s:dir
    endif
endfor

""" Leader
let mapleader=" "


""" Misc settings
syntax enable
set nocompatible
set encoding=utf-8
set showcmd
set wildmenu
set wildmode=list:full
set lazyredraw
set ruler
set title
set complete-=i
set confirm
set display+=lastline
set dir=~/.vim/swap
set hidden
set updatetime=300
set nojoinspaces
set cmdheight=2
set ttimeoutlen=10

" set list
set list


""" No intro screen, no completion messages
set shortmess+=Ic

""" Formatting options
set fo=jcrql2

""" Editor rule and line wrapping
set wrap linebreak
set colorcolumn=121
set textwidth=72


""" Tabs and windows
set winminheight=0
set winminwidth=0

""" Indentation
set softtabstop=-1
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
nnoremap n nzz<BS>n
nnoremap N Nzz<Space>N
nnoremap * *zz<BS>n
nnoremap # #zz<Space>n
nnoremap g* g*zz<BS>n
nnoremap g# g#zz<Space>n

""" Always include the gutter
set signcolumn=yes

" Man
let g:man_hardwrap="78"

" Open help and man in vertical split
autocmd FileType help wincmd L
autocmd FileType man wincmd L

" Don't spell check man pages
autocmd FileType man,* setl nospell

""" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" More intuitive Y
nnoremap Y y$

" Insert mode paste shortcut
inoremap <C-y> <C-r>+

" Other shortcuts
nnoremap gl $
nnoremap gL ^
nnoremap gz 1z=

" Backspace switches to the alternate file
nnoremap <BS> <C-^>

" Up and down arrow keys scroll
noremap <silent> <expr> <Up> v:count == 0 ? "10\<C-u>" : "\<C-u>"
noremap <silent> <expr> <Down> v:count == 0 ? "10\<C-d>" : "\<C-d>"


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

" Fast movement
noremap <silent> <expr> <C-j> v:count == 0 ? "5gj" : "gj"
noremap <silent> <expr> <C-k> v:count == 0 ? "5gk" : "gk"


" Zen mode
nnoremap <leader>z :tab sp<CR>

" Wrap a paragraph
nnoremap <leader>w gwap

" Global search
nnoremap <leader>/ :Rg<CR>

" Set search register
noremap g/ *N


""" Scrolling
noremap <silent> <expr> <C-u> v:count == 0 ? "10\<C-u>" : "\<C-u>"
noremap <silent> <expr> <C-d> v:count == 0 ? "10\<C-d>" : "\<C-d>"
set scrolloff=2
set sidescrolloff=5


""" Shell
set shell=bash

""" Color theming
set t_Co=256
colorscheme sonokai
set cursorline
highlight SpecialKey ctermfg=201
highlight NonText ctermfg=201
highlight Whitespace ctermfg=201
highlight LineNr ctermfg=242
highlight EndOfBuffer cterm=bold ctermfg=90


""" Undo file
set undofile
set undodir=~/.vim/undo

""" Folding
set foldmethod=indent
set nofoldenable

""" Spell check
set spell
set spelllang=en_us
set spellfile=~/.vim/spell/en.utf-8.add
if !empty(glob('.git'))
    if empty(glob('.vim/spell'))
        silent execute '!mkdir -p .vim/spell'
    endif
    set spellfile=.vim/spell/en.utf-8.add,~/.vim/spell/en.utf-8.add
endif

""" grep
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow


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

autocmd BufReadPre,FileReadPre *.asy setl ft=cpp
autocmd FileType plaintex setl fo+=t
autocmd FileType tex setl fo+=t
autocmd FileType text setl fo+=t

redraw!
