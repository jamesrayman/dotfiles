-- vim: sw=2
-- TODO:
-- Snippets
-- Column selection
-- open link
-- lp should paste line <count> times and g<C-a> selection starting at cursor
-- lT and lE should go up or down until line has fewer characters
-- lc should select a column with lT and lE
-- targets.nvim
-- marks.nvim
-- netrw
-- i% and a%
-- treesitter
-- textobjects

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  })
end

vim.opt.runtimepath:prepend(lazypath)
vim.opt.runtimepath:prepend(vim.env.XDG_CONFIG_HOME .. '/nvim')
vim.opt.runtimepath:append(vim.env.XDG_DATA_HOME .. '/nvim')
vim.opt.runtimepath:append(vim.env.XDG_CONFIG_HOME .. '/nvim/after')

vim.opt.packpath:prepend(vim.env.XDG_DATA_HOME .. '/nvim')
vim.opt.packpath:prepend(vim.env.XDG_CONFIG_HOME .. '/nvim')
vim.opt.packpath:append(vim.env.XDG_CONFIG_HOME .. '/nvim/after')
vim.opt.packpath:append(vim.env.XDG_DATA_HOME .. '/nvim/after')

require('lazy').setup({
  'sainnhe/sonokai',
  'tpope/vim-repeat',
  'tpope/vim-commentary',
  'tpope/vim-unimpaired',
  'tpope/vim-eunuch',
  'airblade/vim-gitgutter',
  {
    'ibhagwan/fzf-lua',
    dependecies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('fzf-lua').setup({}) end
  },
  'moll/vim-bbye',
  'aymericbeaumet/vim-symlink',
  'tpope/vim-fugitive',
  'whonore/Coqtail',
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
})

require('nvim-treesitter.configs').setup({
  ensure_installed = 'all',
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
})

vim.o.showcmd = true
vim.o.wildmenu = true
vim.o.wildmode = 'list:full'
vim.o.lazyredraw = true
vim.o.ruler = true
vim.o.title = true
vim.o.confirm = true
vim.o.updatetime = 300
vim.o.ttimeoutlen = 10
vim.o.cursorline = true
vim.o.shortmess = 'filnxtToOFIc'
vim.o.mouse = ''

vim.o.list = true
vim.o.listchars = 'trail:•,tab:┃ ,nbsp:␣,extends:›,precedes:‹'
vim.o.breakindent = true
vim.o.showbreak = ' ↪ '

vim.o.wrap = true
vim.o.linebreak = true
vim.o.colorcolumn = 121
vim.o.textwidth = 72
vim.o.formatoptions = 'jcrql2'

vim.o.winminheight = 0
vim.o.winminwidth = 0

vim.o.softtabstop = -1
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.shiftround = true

vim.o.hlsearch = false
vim.o.wrapscan = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.scrolloff = 2
vim.o.sidescrolloff = 5

vim.o.shell = 'bash'
vim.o.undofile = true

vim.o.foldmethod = 'indent'
vim.o.foldenable = false

vim.o.spell = true
vim.o.spelllang = 'en_us'
vim.o.spelloptions = 'camel'
vim.o.spellfile = vim.env.XDG_CONFIG_HOME .. '/nvim/en.utf-8.add'

vim.o.grepprg = 'rg --vimgrep --smart-case --hidden --follow'
vim.o.diffopt = 'internal,filler,algorithm:myers,indent-heuristic,vertical'

vim.g.mapleader = 'l'

vim.keymap.set('i', '<C-y>', '<C-r>"')
vim.keymap.set('', ',', ':')
vim.keymap.set('n', 'a', 'i')
vim.keymap.set('', 'A', 'I')
vim.keymap.set('n', 'i', 'a')
vim.keymap.set('', 'I', 'A')
vim.keymap.set('', '<C-a>', '^')
vim.keymap.set('', '<TAB>', '$')
vim.keymap.set('', 'h', 'k')
vim.keymap.set('', 'H', 'K')
vim.keymap.set(
  '', '<C-h>', 'v:count == 0 ? "10\\<C-u>" : "\\<C-u>"', { silent = true, expr = true }
)
vim.keymap.set('', '<Space>', 'j')
vim.keymap.set(
  '', '<C-Space>', 'v:count == 0 ? "10\\<C-d>" : "\\<C-d>"', { silent = true, expr = true }
)
vim.keymap.set('', 't', 'b')
vim.keymap.set('', 'T', 'B')
vim.keymap.set('', '<C-t>', 'h')
vim.keymap.set('', 'e', 'w')
vim.keymap.set('', 'E', 'W')
vim.keymap.set('', '<C-e>', 'l')
vim.keymap.set('', 's', 'c')
vim.keymap.set('n', 'ss', 'cc')
vim.keymap.set('', 'S', 'C')
vim.keymap.set('', 'o', 'e')
vim.keymap.set('', 'O', 'E')
vim.keymap.set('v', '<C-o>', 'o')
vim.keymap.set('', 'go', 'ge')
vim.keymap.set('', 'gO', 'gE')
vim.keymap.set('', '<C-n>', ':bnext<CR>')
vim.keymap.set('', '<C-p>', ':bprev<CR>')
vim.keymap.set('', '\\', '<C-^>')
vim.keymap.set('', 'm', 'y')
vim.keymap.set('', 'M', 'yg_')
vim.keymap.set('', 'w', 't')
vim.keymap.set('', 'W', 'T')
vim.keymap.set('', 'j', 'J')
vim.keymap.set('', 'J', 'gJ')
vim.keymap.set('', 'ZA', ':q<CR>')
vim.keymap.set('i', '<C-l>', '<C-x><C-l>')
vim.keymap.set('', '<BS>', '%')
vim.keymap.set('', '<C-d>', '<C-o>')
vim.keymap.set('', '<C-u>', '<C-i>')
vim.keymap.set('', '<C-g>', 'g<C-g>')
vim.keymap.set('', 'c', 'o')
vim.keymap.set('', 'C', 'O')
vim.keymap.set('', '<C-c>', '<C-a>')
vim.keymap.set('', 'gww', 'gww')
vim.keymap.set('n', 'gy', '"+y<Plug>(textobj-entire-a)')
vim.keymap.set('v', 'gy', '"+y')
vim.keymap.set('n', 'gh', 'gk')
vim.keymap.set('n', 'g<Space>', 'gj')
vim.keymap.set(
  'n', 'gs', '&l:sw == 4 ? ":setl sw=8\\<CR>" : &l:sw == 8 ? ":setl sw=2\\<CR>" : ":setl sw=4\\<CR>"',
  { expr = true }
)
vim.keymap.set('n', 'n', 'nzz<BS>n')
vim.keymap.set('n', 'N', 'Nzz<Space>N')
vim.keymap.set('n', '*', '*zz<BS>n')
vim.keymap.set('n', '#', '#zz<Space>n')
vim.keymap.set('n', 'g*', 'g*zz<BS>n')
vim.keymap.set('n', 'g#', 'g#zz<Space>n')
vim.keymap.set('n', 'b', 'i<CR><ESC>')
vim.keymap.set('n', 'B', 'a<CR><ESC>')
vim.keymap.set('', 'gz', '1z=')

vim.keymap.set('n', '<leader>w', 'gwap')
vim.keymap.set('n', '<leader>e', ':FzfLua files<CR>')
vim.keymap.set('n', '<leader>f', ':FzfLua blines<CR>')
vim.keymap.set('n', '<leader>a', ':FzfLua grep<CR>')
vim.keymap.set('n', '<leader>o', ':FzfLua buffers<CR>')

vim.keymap.set('x', 'im', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'im', ': normal vim<CR>', { silent = true })
vim.keymap.set('x', 'am', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'am', ': normal vam<CR>', { silent = true })

vim.keymap.set('', '<C-z>', '') -- tmux training wheels

vim.cmd.colorscheme('sonokai')
vim.cmd.highlight({ 'SpecialKey', 'ctermfg=201' })
vim.cmd.highlight({ 'NonText', 'ctermfg=201' })
vim.cmd.highlight({ 'Whitespace', 'cterm=bold', 'ctermfg=242' })
vim.cmd.highlight({ 'LineNr', 'ctermfg=242' })
vim.cmd.highlight({ 'EndOfBuffer', 'cterm=bold', 'ctermfg=90' })

-- Diff should inherit wrap
vim.api.nvim_create_autocmd(
  'FilterWritePre', { pattern = '*', command = 'if &diff | setlocal wrap< | endif' }
)

vim.opt.matchpairs:append('<:>')
vim.o.indentkeys = ''

vim.g.coqtail_noimap = '1'
vim.g.coqtail_coq_proq = 'coqidetop.opt'

vim.g.netrw_home = vim.env.XDG_DATA_HOME .. '/nvim'

vim.g.man_hardwrap = '78'

vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.asy', command = 'setl ft=cpp' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.sage', command = 'setl ft=python' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.astro', command = 'setl fo+=t' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.astro', command = ' setl sw=2' }
)
vim.api.nvim_create_autocmd('FileType', { pattern = 'plaintex', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'plaintex', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'tex', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'tex', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'text', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'html', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'javascript', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'man', command = 'setl nospell' })
