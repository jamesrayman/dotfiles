" TODO:
" Language features
" Spell check
" Terminal
" NERDTree shortcuts
" Color theme
" Inline calculator


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
Plug 'morhetz/gruvbox'
call plug#end()
filetype plugin on

" aasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetse tsetsetsetsetaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaa aasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetse tsetsetsetsetaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaa aasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetse tsetsetsetsetaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaa aasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetse ttsetsetsetaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaa aasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetse tsetsetsetsetaaaaaaaaaaaaaaaasetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetsetaaaaaaaaaaaaaaaa

""" NERDTree
" Quit Vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | 
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer' . buf | endif

" Use the same NERDTree on every tab
autocmd BufWinEnter * silent NERDTreeMirror
nmap <silent> <C-t> :NERDTreeToggle<CR>
nmap <silent> <C-n> :NERDTree<CR>

""" NERDCommenter
vmap <C-_> <plug>NERDCommenterToggle
nmap <C-_> <plug>NERDCommenterToggle
let NERDSpaceDelims=1

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
noremap <C-l> gt
noremap <C-h> gT

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
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" set hlsearch
" nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

""" Line numbering
set number
set relativenumber

""" Leader
let mapleader=" "

""" Misc keymappings
nnoremap Y y$
tnoremap <Esc> <C-\><C-n>
inoremap <C-v> <C-r>+

""" Shell
set shell=bash\ -l

""" Color themeing
colorscheme gruvbox

""" Undo file
if !empty(glob('~/.vim/undo'))
    silent execute '!mkdir ~/.vim/undo'
endif
set undofile
set undodir=~/.vim/undo

