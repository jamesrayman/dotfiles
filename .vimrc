""" Plugin setup
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'morhetz/gruvbox'
call plug#end()
filetype plugin on

""" NERD Tree
nmap <C-n> :NERDTreeToggle<CR>

""" NERD Commenter
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

""" Tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent

""" Searching
set incsearch
set hlsearch

""" Line numbering
set number
set relativenumber

""" Misc keymappings
nnoremap Y y$
tnoremap <Esc> <C-\><C-n>

""" Color themeing
colorscheme gruvbox

""" Undo file
if !empty(glob('~/.vim/undo'))
    silent execute '!mkdir ~/.vim/undo'
endif
set undofile
set undodir=~/.vim/undo

