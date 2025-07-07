-- TODO:
-- open link
-- textobjects
-- colorscheme
-- Code blocks in comments
-- treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

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
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('fzf-lua').setup({
      winopts = {
        preview = {
          winopts = {
            number = false
          }
        }
      },
      grep = {
        hidden = true
      }
    }) end
  },
  'lewis6991/gitsigns.nvim',
  'aymericbeaumet/vim-symlink',
  { 'echasnovski/mini.icons', version = false },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {
      mappings = {
        toggle = 'M'
      }
    }
  },
})

local gitsigns = require('gitsigns')
gitsigns.setup{}

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
vim.o.shortmess = 'filnxtToOFIc'
vim.o.mouse = ''
vim.o.cursorline = true

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
vim.keymap.set('n', 'gh', 'gk', { desc = 'Up [count] display lines' })
vim.keymap.set('n', 'g<Space>', 'gj', { desc = 'Down [count] display lines' })
vim.keymap.set(
  'n', 'gs', '&l:sw == 4 ? ":setl sw=8\\<CR>" : &l:sw == 8 ? ":setl sw=2\\<CR>" : ":setl sw=4\\<CR>"',
  { expr = true, desc = 'Cycle between shiftwidths' }
)
vim.keymap.set('', 'gz', '1z=')
vim.keymap.set('', '+', '?')
vim.keymap.set('', '<C-q>', '<C-y>')
vim.keymap.set('', '<C-y>', '<C-e>')
vim.keymap.set('', 'b', 't')
vim.keymap.set('', 'B', 'T')
vim.keymap.set('', 'gH', 'H')
vim.keymap.set('', 'gM', 'M')
vim.keymap.set('', 'gL', 'L')
vim.keymap.set('', '-', '<Cmd>Explore<CR>')
vim.keymap.set('n', '_', '<Cmd>SmartFileSwitch<CR>', { silent = true })

vim.keymap.set('n', 'l', '<Plug>(MatchitNormalForward)')
vim.keymap.set('x', 'l', '<Plug>(MatchitVisualForward)')
vim.keymap.set('o', 'l', '<Plug>(MatchitOperationForward)')
vim.keymap.set('n', 'L', '<Plug>(MatchitNormalBackward)')
vim.keymap.set('x', 'L', '<Plug>(MatchitVisualBackward)')
vim.keymap.set('o', 'L', '<Plug>(MatchitOperationBackward)')
vim.keymap.set('x', 'al', '<Plug>(MatchitVisualTextObject)')

vim.keymap.set('n', ']s', ']S')
vim.keymap.set('n', '[s', '[S')
vim.keymap.set('n', ']S', ']s')
vim.keymap.set('n', '[S', '[s')

vim.keymap.set('n', '<Leader>e', FzfLua.files)
vim.keymap.set('n', '<Leader>F', FzfLua.blines)
vim.keymap.set('n', '<Leader>f', FzfLua.lines)
vim.keymap.set('n', '<Leader>a', FzfLua.live_grep)
vim.keymap.set('n', '<Leader>A', function() FzfLua.live_grep{ cwd = vim.fn.expand('%:p:h') } end)
vim.keymap.set('n', '<Leader>*', FzfLua.grep_cword)
vim.keymap.set('n', '<Leader>o', FzfLua.buffers)
vim.keymap.set('n', '<Leader>q', FzfLua.quickfix)
vim.keymap.set('n', "<Leader>'", FzfLua.marks)
vim.keymap.set('n', '<Leader>j', FzfLua.jumps)
vim.keymap.set('n', '<Leader>r', FzfLua.resume)
vim.keymap.set('n', '<Leader>R', FzfLua.oldfiles)
vim.keymap.set('n', '<Leader>m', FzfLua.git_diff)
vim.keymap.set('n', '<Leader>H', FzfLua.git_hunks)

vim.keymap.set('n', '<Leader>hp', gitsigns.preview_hunk_inline)
vim.keymap.set('n', '<Leader>hs', gitsigns.stage_hunk)
vim.keymap.set('n', '<Leader>hu', gitsigns.reset_hunk)
vim.keymap.set('n', '<Leader>hd', function() vim.cmd.tabnew('%'); gitsigns.diffthis() end)
vim.keymap.set('n', '<Leader>hb', function() gitsigns.blame_line({ full = true }) end)
vim.keymap.set('n', '<Leader>hB', gitsigns.blame)
vim.keymap.set('n', '<Leader>hq', function() gitsigns.setqflist('all', { open = false }) end)

vim.keymap.set('n', '<Leader>n', '<Cmd>cnext<CR>')
vim.keymap.set('n', '<Leader>p', '<Cmd>cprevious<CR>')
vim.keymap.set('n', '<Leader>c', '<Cmd>DiffCorrected<CR>')
vim.keymap.set('n', '<Leader>C', '<Cmd>AcceptCorrected<CR>')

vim.keymap.set('x', 'im', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'im', ': normal vim<CR>', { silent = true })
vim.keymap.set('x', 'am', ':<C-u> normal! `[v`]<CR>', { silent = true })
vim.keymap.set('o', 'am', ': normal vam<CR>', { silent = true })

vim.keymap.set('x', 'ie', ':<C-u> normal! ggVG<CR>', { silent = true })
vim.keymap.set('o', 'ie', ':normal vie<CR>', { silent = true })
vim.keymap.set('x', 'ae', ':<C-u> normal! ggVG<CR>', { silent = true })
vim.keymap.set('o', 'ae', ':normal vae<CR>', { silent = true })

vim.keymap.set('', '<C-z>', '', { desc = 'tmux training wheels' })

vim.cmd.highlight({ 'Normal', 'guibg=None' })
-- vim.cmd.highlight({ 'SpecialKey', 'ctermfg=201' })
-- vim.cmd.highlight({ 'NonText', 'ctermfg=201' })
-- vim.cmd.highlight({ 'Whitespace', 'cterm=bold', 'ctermfg=242' })
-- vim.cmd.highlight({ 'EndOfBuffer', 'cterm=bold', 'ctermfg=90' })
-- vim.cmd.highlight({ 'SpellBad', 'ctermfg=203 ctermbg=52 cterm=none' })
-- vim.cmd.highlight({ 'SpellLocal', 'ctermfg=203 ctermbg=52 cterm=none' })
-- vim.cmd.highlight({ 'SpellCap', 'ctermfg=203 cterm=none' })
-- vim.cmd.highlight({ 'SpellRare', 'ctermfg=215 cterm=none' })

vim.opt.guicursor:remove{ 't:block-blinkon500-blinkoff500-TermCursor' }

vim.api.nvim_create_user_command('SmartFileSwitch', function()
  current_file = vim.fn.expand('%')
  complement_suffixes = {
    { '.cpp', '.h' },
    { '.c', '.h' },
    { '.h', '.c' },
    { '.h', '.cpp' },
  }
  for _, p in ipairs(complement_suffixes) do
    local suffix, complement_suffix = p[1], p[2]
    if current_file:sub(-string.len(suffix)) == suffix then
      local complement_file = current_file:sub(1, -string.len(suffix)-1) .. complement_suffix
      if vim.uv.fs_stat(complement_file) then
        vim.cmd.e { complement_file }
        break
      end
    end
  end
end, { desc = 'Switch to the current file\'s "complement," e.g. a cpp file\'s header' })

vim.api.nvim_create_user_command('DiffCorrected', function()
  local current_file = vim.fn.expand('%')
  local corrected_file = current_file .. '.corrected'
  if not vim.uv.fs_stat(corrected_file) then
    vim.api.nvim_echo({ { 'No .corrected file found' } }, true, { err = true })
    return
  end
  vim.cmd.tabnew(corrected_file)
  vim.cmd.diffthis()
  vim.cmd.vsplit(current_file)
  vim.cmd.diffthis()
end, { desc = 'Diff the current file with it\'s .corrected file' })

vim.api.nvim_create_user_command('AcceptCorrected', function()
  local current_file = vim.fn.expand('%')
  local corrected_file = current_file .. '.corrected'
  if not vim.uv.fs_stat(corrected_file) then
    vim.api.nvim_echo({ { 'No .corrected file found' } }, true, { err = true })
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.readfile(corrected_file))
  vim.fn.delete(corrected_file)
  vim.cmd.write()
end, { desc = 'Replace the current file with it\'s .corrected file' })

-- Diff should inherit wrap
vim.api.nvim_create_autocmd(
  'FilterWritePre', { pattern = '*', command = 'if &diff | setlocal wrap< | endif' }
)

vim.opt.matchpairs:append('<:>')
vim.o.indentkeys = ''

vim.g.netrw_home = vim.env.XDG_DATA_HOME .. '/nvim'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

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
  { 'BufReadPost' }, { callback = function()
    pcall(vim.api.nvim_win_set_cursor, 0, vim.api.nvim_buf_get_mark(0, '"'))
  end }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.sage', command = 'setl ft=python' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.astro', command = 'setl fo+=t' }
)
vim.api.nvim_create_autocmd(
  { 'BufReadPre', 'FileReadPre' }, { pattern = '*.astro', command = 'setl sw=2' }
)
vim.api.nvim_create_autocmd('FileType', { pattern = 'xml', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'plaintex', command = 'setl sw=2 fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'tex', command = 'setl sw=2 fo+= t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'text', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'html', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'javascript', command = 'setl sw=2' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'man', command = 'setl nospell' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'lua', command = 'setl sw=2' })
