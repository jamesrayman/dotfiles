" TODO:
" Language features
" Spell check
" Terminal
" Inline calculator
" config files (e.g. comment styles, dictionaries, etc)
" Separate large features into plugins
" gitgutter: configure
" vim in terminal


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
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
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
vnoremap <C-_> <plug>NERDCommenterToggle
nnoremap <C-_> <plug>NERDCommenterToggle
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1


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

""" Leader
let mapleader=" "

""" Misc keymappings
nnoremap Y y$
inoremap <C-v> <C-r>+
nnoremap <C-s> :w<CR>

""" Scrolling
nnoremap <silent> <C-d> @='5gjzz'<CR>
nnoremap <silent> <C-u> @='5gkzz'<CR>
set scrolloff=2
set sidescrolloff=5

""" Shell
set shell=/usr/bin/env\ VIMSH=a\ bash\ -l

""" Color themeing
set t_Co=256
colorscheme sonokai
set cursorline
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
    set noequalalways
    term
    f terminal
endfunction

function! ToggleTerminal()
    let index = bufwinnr('terminal')
    if index == -1
        call MakeTerminalWindow()
    elseif bufname() == 'terminal'
        wincmd p
    else
        exec index . "wincmd w"
    endif
endfunction

command ToggleTerminal call ToggleTerminal()

tnoremap <Esc> <C-\><C-n>
nnoremap <silent> <M-k>; :ToggleTerminal<CR>
tnoremap <silent> <M-k>; <C-\><C-n>:ToggleTerminal<CR>
inoremap <M-k>; <Esc>:ToggleTerminal<CR>

""" Folding
set foldmethod=indent
set nofoldenable


""" Diff

" Diff should inherit wrap
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" :D[iff]r[egs] a b should do a diff check of registers a and b in a new tab


""" Language specific

""" make a text-obj funciton. Search should be across multiple lines see above plugin
for s:c in ['$', '%', '.', ':', ',', '-', '*', '+', '#', '/', ';']
    exec 'xnoremap i' . s:c . ' :<C-u> keeppattern normal! T' . s:c . 'vt' . s:c . '<CR>'
    exec 'onoremap i' . s:c . ' :normal vi' . s:c . '<CR>'
    exec 'xnoremap a' . s:c . ' :<C-u> keeppattern normal! F' . s:c . 'vf' . s:c . '<CR>'
    exec 'onoremap a' . s:c . ' :normal va' . s:c . '<CR>'
endfor

set matchpairs+=<:>

" g/ should search current selection/word under cursor without moving cursor
" g? should act similarly

" Training wheels
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

