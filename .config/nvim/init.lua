-- vim: sw=2
-- TODO:
-- Snippets
-- open link
-- lp should paste line <count> times and g<C-a> selection starting at cursor
-- lT and lE should go up or down until line has fewer characters
-- lc should select a column with lT and lE
-- targets.nvim
-- marks.nvim
-- i% and a%
-- textobjects
-- colorscheme
-- Code blocks in comments

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
  'tpope/vim-unimpaired',
  'tpope/vim-eunuch',
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('fzf-lua').setup({}) end
  },
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true
  },
  'lewis6991/gitsigns.nvim',
  'moll/vim-bbye',
  'aymericbeaumet/vim-symlink',
  'anuvyklack/hydra.nvim',
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  { 'numToStr/Comment.nvim', lazy = false }
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
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = 'ge',
      scope_incremental = 'gs',
      node_decremental = 'gt'
    }
  }
})

require('Comment').setup()

local gitsigns = require('gitsigns')
gitsigns.setup()

local hydra = require("hydra")

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
vim.o.spellsuggest = 'best,9'

vim.o.grepprg = 'rg --vimgrep --smart-case --hidden --follow'
vim.o.diffopt = 'internal,filler,algorithm:myers,indent-heuristic,vertical'

vim.cmd('let mapleader="\\<BS>"')

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
vim.keymap.set('x', '<C-o>', 'o')
vim.keymap.set('', 'go', 'ge')
vim.keymap.set('', 'gO', 'gE')
vim.keymap.set('', '<C-n>', ':bnext<CR>')
vim.keymap.set('', '<C-p>', ':bprev<CR>')
vim.keymap.set('', '\\', '<C-^>')
vim.keymap.set('', 'm', 'y')
vim.keymap.set('n', 'mm', 'yy')
vim.keymap.set('n', 'M', 'yg_')
vim.keymap.set('', 'j', 'J')
vim.keymap.set('', 'J', 'gJ')
vim.keymap.set('', 'ZA', ':q<CR>')
vim.keymap.set('i', '<C-l>', '<C-x><C-l>')
vim.keymap.set('', 'l', '%')
vim.keymap.set('', '<BS>', '<Nop>')
vim.keymap.set('', '<C-d>', '<C-o>')
vim.keymap.set('', '<C-u>', '<C-i>')
vim.keymap.set('', '<C-g>', 'g<C-g>')
vim.keymap.set('', 'c', 'o')
vim.keymap.set('', 'C', 'O')
vim.keymap.set('', '<C-c>', '<C-a>')
vim.keymap.set('', 'gww', 'gww')
vim.keymap.set('n', 'gm', ':%y+<CR>')
vim.keymap.set('x', 'gm', '"+y')
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

vim.keymap.set('n', 'gy', 'ggVG"+y')

vim.keymap.set('n', ']s', ']S')
vim.keymap.set('n', '[s', '[S')
vim.keymap.set('n', ']S', ']s')
vim.keymap.set('n', '[S', '[s')

vim.keymap.set('n', '<Leader>w', 'gwap')
vim.keymap.set('n', '<Leader>e', ':FzfLua files<CR>')
vim.keymap.set('n', '<Leader>f', ':FzfLua blines<CR>')
vim.keymap.set('n', '<Leader>a', ':FzfLua grep<CR>')
vim.keymap.set('n', '<Leader>o', ':FzfLua buffers<CR>')

vim.keymap.set('x', 'im', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'im', ': normal vim<CR>', { silent = true })
vim.keymap.set('x', 'am', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'am', ': normal vam<CR>', { silent = true })

vim.keymap.set('x', 'ie', ':<C-u> normal! ggVG<CR>', { silent = true })
vim.keymap.set('o', 'ie', ':normal vie<CR>', { silent = true })
vim.keymap.set('x', 'ae', ':<C-u> normal! ggVG<CR>', { silent = true })
vim.keymap.set('o', 'ae', ':normal vae<CR>', { silent = true })

vim.keymap.set('', '<C-z>', '') -- tmux training wheels

vim.cmd.colorscheme('sonokai')
vim.cmd.highlight({ 'SpecialKey', 'ctermfg=201' })
vim.cmd.highlight({ 'NonText', 'ctermfg=201' })
vim.cmd.highlight({ 'Whitespace', 'cterm=bold', 'ctermfg=242' })
vim.cmd.highlight({ 'LineNr', 'ctermfg=242' })
vim.cmd.highlight({ 'EndOfBuffer', 'cterm=bold', 'ctermfg=90' })
vim.cmd.highlight({ 'SpellBad', 'ctermfg=203 ctermbg=52 cterm=none' })
vim.cmd.highlight({ 'SpellLocal', 'ctermfg=203 ctermbg=52 cterm=none' })
vim.cmd.highlight({ 'SpellCap', 'ctermfg=203 cterm=none' })
vim.cmd.highlight({ 'SpellRare', 'ctermfg=215 cterm=none' })

vim.api.nvim_create_user_command('SmartFileSwitch', function(opts)
  current_file = vim.fn.expand('%')
  complement_suffixes = {
    { '.cpp', '.h' },
    { '.c', '.h' },
    { '.h', '.c' },
    { '.h', '.cpp' },
  }
  for _, p in ipairs(complement_suffixes) do
    suffix, complement_suffix = p[1], p[2]
    if current_file:sub(-string.len(suffix)) == suffix then
      complement_file = current_file:sub(1, -string.len(suffix)-1) .. complement_suffix
      if vim.uv.fs_stat(complement_file) then
        vim.cmd.e { complement_file }
        break
      end
    end
  end
end, { desc = 'Switch to the current file\'s "complement,", e.g. a cpp file\'s header' })

vim.keymap.set('n', '-', ': SmartFileSwitch<CR>', { silent = true })

vim.cmd('dig %o 8240')
vim.cmd('dig %% 8241')

-- Diff should inherit wrap
vim.api.nvim_create_autocmd(
  'FilterWritePre', { pattern = '*', command = 'if &diff | setlocal wrap< | endif' }
)

vim.opt.matchpairs:append('<:>')
vim.o.indentkeys = ''

vim.g.netrw_home = vim.env.XDG_DATA_HOME .. '/nvim'

vim.g.man_hardwrap = '78'

vim.filetype.add({
  extension = {
    asy = 'cpp',
    sage = 'python'
  }
})

vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.sage', command = 'setl ft=python' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.astro', command = 'setl fo+=t' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.astro', command = ' setl sw=2' }
)
vim.api.nvim_create_autocmd('FileType', { pattern = 'xml', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'plaintex', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'plaintex', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'tex', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'tex', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'text', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'html', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'javascript', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'man', command = 'setl nospell' })


local git_hydra_hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]

hydra({
   name = 'Git',
   hint = git_hydra_hint,
   config = {
      buffer = bufnr,
      color = 'pink',
      invoke_on_body = true,
      hint = {
         border = 'rounded'
      },
      on_enter = function()
         vim.cmd 'mkview'
         vim.cmd 'silent! %foldopen!'
         vim.bo.modifiable = false
         gitsigns.toggle_signs(true)
         gitsigns.toggle_linehl(true)
      end,
      on_exit = function()
         local cursor_pos = vim.api.nvim_win_get_cursor(0)
         vim.cmd 'loadview'
         vim.api.nvim_win_set_cursor(0, cursor_pos)
         vim.cmd 'normal zv'
         gitsigns.toggle_signs(false)
         gitsigns.toggle_linehl(false)
         gitsigns.toggle_deleted(false)
      end,
   },
   mode = {'n','x'},
   body = '<Leader>hh',
   heads = {
      { 'J',
         function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gitsigns.next_hunk() end)
            return '<Ignore>'
         end,
         { expr = true, desc = 'next hunk' } },
      { 'K',
         function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gitsigns.prev_hunk() end)
            return '<Ignore>'
         end,
         { expr = true, desc = 'prev hunk' } },
      { 's', ':Gitsigns stage_hunk<CR>', { silent = true, desc = 'stage hunk' } },
      { 'u', gitsigns.undo_stage_hunk, { desc = 'undo last stage' } },
      { 'S', gitsigns.stage_buffer, { desc = 'stage buffer' } },
      { 'p', gitsigns.preview_hunk, { desc = 'preview hunk' } },
      { 'd', gitsigns.toggle_deleted, { nowait = true, desc = 'toggle deleted' } },
      { 'b', gitsigns.blame_line, { desc = 'blame' } },
      { 'B', function() gitsigns.blame_line{ full = true } end, { desc = 'blame show full' } },
      { '/', gitsigns.show, { exit = true, desc = 'show base file' } },
      { '<Enter>', '<Cmd>Neogit<CR>', { exit = true, desc = 'Neogit' } },
      { 'q', nil, { exit = true, nowait = true, desc = 'exit' } },
   }
})
