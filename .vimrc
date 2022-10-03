" TODO:
" Language features
" config files (e.g. comment styles, dictionaries, etc)
" Separate large features into plugins
" Snippets
" Only vsp help and man if columns > 165, shrink to 80 cols
" Annotate everything
" Column selection
" Git column off by default
" Unicode.vim
" open link
" Redo in Lua
" lp should paste line <count> times and g<C-a> selection starting at cursor
" lT and lE should go up or down until line has fewer characters
" lc should select a column with lT and lE
" swap i and a
" targets.nvim
" marks.nvim
" netrw


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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'moll/vim-bbye'
Plug 'aymericbeaumet/vim-symlink'
Plug 'tpope/vim-fugitive'
Plug 'whonore/Coqtail'
call plug#end()
filetype plugin on


""" Make directories
for s:dir in ['/undo', '/spell', '/swap']
    if empty(glob(data_dir . s:dir))
        silent execute '!mkdir -p ' . data_dir . s:dir
    endif
endfor

""" Leader
let mapleader="l"

""" Coq
let g:coqtail_noimap="1"
let g:coqtail_coq_proq="coqidetop.opt"

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
set listchars=trail:•,tab:┃\ ,nbsp:␣,extends:›,precedes:‹
set breakindent
set showbreak=\ ↪\ 

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
set nowrapscan
nnoremap n nzz<BS>n
nnoremap N Nzz<Space>N
nnoremap * *zz<BS>n
nnoremap # #zz<Space>n
nnoremap g* g*zz<BS>n
nnoremap g# g#zz<Space>n

" No tab line
set showtabline=0

" Man
let g:man_hardwrap="78"

" Open help and man in vertical split
autocmd FileType help wincmd L
autocmd FileType man wincmd L

" Don't spell check man pages
autocmd FileType man setl nospell

""" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" Insert mode paste shortcut
inoremap <C-y> <C-r>"

" Other shortcuts
noremap , :
noremap : ,
noremap gz 1z=
noremap j gj
noremap k gk
noremap <Space> l
noremap <BS> e
noremap e j
noremap t k
onoremap t t
noremap T t
noremap <C-n> <ESC>
noremap <C-p> <ESC>
noremap \ <C-^>
noremap Q :q<CR>
noremap y m
noremap m y
noremap Y M
" More intuitive Y
noremap M yg_
noremap f /
noremap F ?
noremap / f
noremap ? F
nnoremap S i<CR><ESC>
inoremap <C-l> <C-x><C-l>


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
colorscheme sonokai
set cursorline
highlight SpecialKey ctermfg=201
highlight NonText ctermfg=201
highlight Whitespace cterm=bold ctermfg=242
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
