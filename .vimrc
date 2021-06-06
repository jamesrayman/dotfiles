" TODO:
" Language features
" Spell check
" Terminal
" NERDTree shortcuts
" Inline calculator
" Windows and tabs
" config files (e.g. comment styles, dictionaries, etc)
" Operator modes
" Separate large features into plugins


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
call plug#end()
filetype plugin on

""" NERDTree
nnoremap <expr> <silent> <C-n> bufname() =~# 'NERD_tree_\d\+' ? "\<C-w>p" : ":NERDTreeFocus\<CR>"

" Close tab if NERDTree is the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~# 'NERD_tree_\d\+' && bufname('%') !~# 'NERD_tree_\d\+' && winnr('$') > 1 | 
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer' . buf | endif

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror


""" NERDCommenter
vmap <C-_> <plug>NERDCommenterToggle
nmap <C-_> <plug>NERDCommenterToggle
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1


""" Misc settings
syntax enable
set nocompatible
set encoding=utf-8
set showcmd
set wildmenu
set lazyredraw
set ruler

""" Editor rule and line wrapping
set wrap linebreak nolist
set colorcolumn=121

""" Tabs and windows
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

""" Leader
let mapleader=" "

""" Misc keymappings
nnoremap Y y$
inoremap <C-v> <C-r>+
nnoremap <C-s> :w<CR>

""" Scrolling
nnoremap <silent> <C-d> @='5gjzz'<CR>
nnoremap <silent> <C-u> @='5gkzz'<CR>

""" Shell
set shell=/bin/bash\ -l

""" Color themeing
set t_Co=256
colorscheme sonokai
highlight SpecialKey ctermfg=201

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
    f terminal
endfunction

function! ToggleTerminal()
    let index = bufwinnr('terminal')
    if index == -1
        call MakeTerminalWindow()
        exec "normal i"
    elseif bufname() == 'terminal'
        wincmd p
    else
        exec index . "wincmd w"
        exec "normal i"
    endif
endfunction

command ToggleTerminal :call ToggleTerminal()

tnoremap <Esc> <C-\><C-n>
nnoremap <silent> <M-;> :ToggleTerminal<CR>
tnoremap <silent> <M-;> <C-\><C-n>:ToggleTerminal<CR>
inoremap <M-;> <Esc>:ToggleTerminal<CR>


""" Language specific

let g:NERDCustomDelimiters = { 'json': { 'left': '//', 'right': '' }}

xnoremap i$ :<C-u> keepnormal normal! T$vt$<CR>
onoremap i$ :normal vi$<CR>
xnoremap a$ :<C-u> keepnormal normal! F$vf$<CR>
onoremap a$ :normal va$<CR>


