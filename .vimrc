""" TODO
""" snippets

""" MISC SETTINGS
syntax enable
set encoding=utf-8
set showcmd
set wildmenu
set lazyredraw
set ruler

""" TABS
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent

""" SEARCHING
set showmatch
set incsearch
set hlsearch

""" LINE NUMBERING
set number
set relativenumber

""" MISC KEYMAPPINGS
nnoremap Y y$
tnoremap <Esc> <C-\><C-n>

""" PLUGIN SETUP
" set nocompatible
" filetype off
" call plug#begin('~/.vim/plugged')
" Plug 'scrooloose/nerdtree'
" Plug 'Raimondi/delimitMate'
" call plug#end()
" filetype plugin indent on 

""" COLOR THEMEING
colorscheme ron
