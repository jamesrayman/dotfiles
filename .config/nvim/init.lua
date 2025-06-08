-- vim: sw=2

-- TODO:
-- Snippets
-- open link
-- <Leader>p should paste line <count> times and g<C-a> selection starting at cursor
-- <Leader>T and <Leader>E should go up or down until line has fewer characters
-- <Leader>c should select a column with <Leader>T and <Leader>E
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
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({
      })

      vim.cmd('colorscheme github_dark_high_contrast')
    end,
  },
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
  { 'echasnovski/mini.icons', version = false },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      keys = {
        scroll_down = '<C-Space>',
        scroll_up = '<C-h>'
      },
      delay = function(ctx)
        return ctx.plugin and 0 or 1500
      end,
    }
  }
})

local gitsigns = require('gitsigns')
gitsigns.setup()


function next_hunk()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() gitsigns.next_hunk() end)
  return '<Ignore>'
end

function prev_hunk()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() gitsigns.prev_hunk() end)
  return '<Ignore>'
end

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
vim.o.textwidth = 72
vim.o.formatoptions = 'jcrql2'

vim.o.winminheight = 0
vim.o.winminwidth = 0

vim.o.softtabstop = -1
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.shiftround = true

vim.o.hlsearch = true
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
vim.cmd('let maplocalleader="\\<BS>"')

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
vim.keymap.set('', '<C-n>', next_hunk)
vim.keymap.set('', '<C-p>', prev_hunk)
vim.keymap.set('', '\\', '<C-^>')
vim.keymap.set('', 'j', 'J')
vim.keymap.set('', 'J', 'gJ')
vim.keymap.set('', 'ZA', ':q<CR>')
vim.keymap.set('', 'ZT', ':tabclose<CR>')
vim.keymap.set('i', '<C-l>', '<C-x><C-l>')
vim.keymap.set('', '<BS>', '<Nop>')
vim.keymap.set('', '<C-d>', '<C-i>')
vim.keymap.set('', '<C-u>', '<C-o>')
vim.keymap.set('', '<C-g>', 'g<C-g>')
vim.keymap.set('', 'c', 'o')
vim.keymap.set('', 'C', 'O')
vim.keymap.set('', '<C-c>', '<C-a>')
vim.keymap.set('', 'gww', 'gww')
vim.keymap.set('n', 'gm', ':%y+<CR>', { desc = 'Yank entire file (system clipboard)' })
vim.keymap.set('x', 'gm', '"+y', { desc = 'Yank entire file (system clipboard)' })
vim.keymap.set('n', 'gh', 'gk', { desc = 'Up [count] display lines' })
vim.keymap.set('n', 'g<Space>', 'gj', { desc = 'Down [count] display lines' })
vim.keymap.set(
  'n', 'gs', '&l:sw == 4 ? ":setl sw=8\\<CR>" : &l:sw == 8 ? ":setl sw=2\\<CR>" : ":setl sw=4\\<CR>"',
  { expr = true, desc = 'Cycle between shiftwidths' }
)
vim.keymap.set('n', 'n', 'nzz<BS>n')
vim.keymap.set('n', 'N', 'Nzz<Space>N')
vim.keymap.set('n', 'b', 'i<CR><ESC>')
vim.keymap.set('n', 'B', 'a<CR><ESC>')
vim.keymap.set('', 'gz', '1z=')
vim.keymap.set('', '+', '?')
vim.keymap.set('', '<C-q>', '<C-y>')
vim.keymap.set('', '<C-y>', '<C-e>')

vim.keymap.set('n', 'l', '<Plug>(MatchitNormalForward)')
vim.keymap.set('x', 'l', '<Plug>(MatchitVisualForward)')
vim.keymap.set('o', 'l', '<Plug>(MatchitOperationForward)')
vim.keymap.set('n', 'L', '<Plug>(MatchitNormalBackward)')
vim.keymap.set('x', 'L', '<Plug>(MatchitVisualBackward)')
vim.keymap.set('o', 'L', '<Plug>(MatchitOperationBackward)')
vim.keymap.set('x', 'al', '<Plug>(MatchitVisualTextObject)')

vim.keymap.set('n', 'gy', 'ggVG"+y')

vim.keymap.set('n', ']s', ']S')
vim.keymap.set('n', '[s', '[S')
vim.keymap.set('n', ']S', ']s')
vim.keymap.set('n', '[S', '[s')

vim.keymap.set('n', '<Leader>e', ':FzfLua files<CR>')
vim.keymap.set('n', '<Leader>f', ':FzfLua blines<CR>')
vim.keymap.set('n', '<Leader>F', ':FzfLua live_grep<CR>')
vim.keymap.set('n', '<Leader>*', ':FzfLua grep_cword<CR>')
vim.keymap.set('n', '<Leader>o', ':FzfLua buffers<CR>')
vim.keymap.set('n', '<Leader>q', ':FzfLua quickfix<CR>')
vim.keymap.set('n', '<Leader>r', ':FzfLua resume<CR>')

vim.keymap.set('x', 'im', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'im', ': normal vim<CR>', { silent = true })
vim.keymap.set('x', 'am', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'am', ': normal vam<CR>', { silent = true })

vim.keymap.set('x', 'ie', ':<C-u> normal! ggVG<CR>', { silent = true })
vim.keymap.set('o', 'ie', ':normal vie<CR>', { silent = true })
vim.keymap.set('x', 'ae', ':<C-u> normal! ggVG<CR>', { silent = true })
vim.keymap.set('o', 'ae', ':normal vae<CR>', { silent = true })

vim.keymap.set('', '<C-z>', '', { desc = 'tmux training wheels' })

-- vim.cmd.highlight({ 'SpecialKey', 'ctermfg=201' })
-- vim.cmd.highlight({ 'NonText', 'ctermfg=201' })
-- vim.cmd.highlight({ 'Whitespace', 'cterm=bold', 'ctermfg=242' })
-- vim.cmd.highlight({ 'LineNr', 'ctermfg=242' })
-- vim.cmd.highlight({ 'EndOfBuffer', 'cterm=bold', 'ctermfg=90' })
-- vim.cmd.highlight({ 'SpellBad', 'ctermfg=203 ctermbg=52 cterm=none' })
-- vim.cmd.highlight({ 'SpellLocal', 'ctermfg=203 ctermbg=52 cterm=none' })
-- vim.cmd.highlight({ 'SpellCap', 'ctermfg=203 cterm=none' })
-- vim.cmd.highlight({ 'SpellRare', 'ctermfg=215 cterm=none' })

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
end, { desc = 'Switch to the current file\'s "complement," e.g. a cpp file\'s header' })

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

vim.g.man_hardwrap = 1

vim.filetype.add({
  extension = {
    asy = 'cpp',
    sage = 'python'
  }
})

vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('auto-hlsearch', { clear = true }),
  callback = function ()
    if vim.o.hlsearch ~= (vim.fn.searchcount().exact_match ~= 0) then
      vim.o.hlsearch = vim.fn.searchcount().exact_match ~= 0
    end
  end
})

function infopane ()
  vim.g.infopane = vim.fn.system({
    'tmux', 'split-window', '-h', '-l', '80', '-P', '-F', '#{pane_id}',
    string.format('VIMSERVER=\'%s\' bash', vim.v.servername)
  }):gsub('%s+', '')
end

function oxpecker_break ()
  vim.fn.system({
    'tmux', 'send-keys', '-t', vim.g.infopane, 'ls\n'
  })
end

vim.api.nvim_create_user_command('Oxpecker', function ()
  infopane()
end, { desc = 'Oxpecker is the OxCaml de-bugger' })

vim.api.nvim_create_user_command('OxpeckerBreak', function ()
  oxpecker_break()
end, { desc = '' })


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
