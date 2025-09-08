-- TODO:
-- textobjects
-- Code blocks in comments
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  }
end

vim.opt.runtimepath:prepend(lazypath)
vim.opt.runtimepath:prepend(vim.env.XDG_CONFIG_HOME .. '/nvim')
vim.opt.runtimepath:append(vim.env.XDG_DATA_HOME .. '/nvim')
vim.opt.runtimepath:append(vim.env.XDG_CONFIG_HOME .. '/nvim/after')

vim.opt.packpath:prepend(vim.env.XDG_DATA_HOME .. '/nvim')
vim.opt.packpath:prepend(vim.env.XDG_CONFIG_HOME .. '/nvim')
vim.opt.packpath:append(vim.env.XDG_CONFIG_HOME .. '/nvim/after')
vim.opt.packpath:append(vim.env.XDG_DATA_HOME .. '/nvim/after')

vim.opt.guicursor:remove{ 't:block-blinkon500-blinkoff500-TermCursor' }

vim.cmd('let mapleader="\\<BS>"')
vim.cmd('let maplocalleader="\\<BS>"')

require'lazy'.setup {
  { 'nvim-treesitter/nvim-treesitter', branch = 'master', lazy = false, build = ':TSUpdate' },
  'Shatur/neovim-ayu',
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require'fzf-lua'.setup {
      'hide',
      fzf_opts = {
        ['--cycle'] = true,
      },
      defaults = { compat_warn = false },
      winopts = {
        preview = {
          winopts = {
            number = false
          }
        }
      },
      keymap = {
        fzf = {
          true,
          ['ctrl-q'] = 'select-all+accept'
        }
      },
      actions = {
        files = {
          true,
          ['ctrl-l'] = require'fzf-lua'.actions.file_split
        }
      },
      grep = {
        hidden = true
      }
    }
    end
  },
  'lewis6991/gitsigns.nvim',
  'aymericbeaumet/vim-symlink',
  -- 'neovim/nvim-lspconfig',
}

require'ayu'.setup {
  terminal = false,
  overrides = {
    Normal = { bg = 'none' },
    SignColumn = { bg = 'none' },
    NonText = { fg = '#636a72' },
    SpecialKey = { fg = '#ff00ff' },
    Comment = { italic = false },
    LineNr = { fg = '#636a72' },
    SpellBad = { undercurl = true, fg = '#d95757', sp = '#d95757' },
    SpellLocal = { undercurl = true, fg = '#d95757', sp = '#d95757' },
    SpellCap = { undercurl = false, fg = '#d95757' },
    SpellRare = { undercurl = true, fg = '#e6b450', sp = '#e6b450' },
    Visual = { bg = '#2e2e2e' },
    CursorLine = { bg = '#202020' },
    Underlined = { fg = '#39bae6' },
    MatchParen = { underline = false, bg = '#404040' },
    IncSearch = { fg = '#ffc95a', bg = '#5a461f' },
    CurSearch = { fg = '#ffc95a', bg = '#5a461f' },
    Search = { fg = '#ffc95a', bg = 'none' },
    WinSeparator = { bg = 'none' },
    StatusLine = { fg = '#bfbdb6', bg = '#2e2e2e' },
  },
}
vim.cmd.colorscheme'ayu'

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    -- vim
    'c', 'lua', 'vim', 'vimdoc', 'query',
    -- other popular general purpose languages
    'rust', 'python', 'java',
    -- markup
    'markdown', 'markdown_inline',
    'bibtex', 'latex',
    -- web dev
    'html', 'css', 'javascript', 'typescript',
    'astro', 'svelte', 'sql', 'php',
    'dockerfile',
    -- ocaml
    'ocaml', 'ocaml_interface', 'menhir',
    -- serialization
    'json', 'xml', 'yaml',
    -- other DSLs
    'bash', 'make', 'diff', 'readline',
    'sway', 'tmux', 'ini', 'toml',
    -- injections
    'regex', 'printf', 'comment',
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}

local gitsigns = require'gitsigns'
gitsigns.setup {
  on_attach = function(bufnr)
    local function next_hunk()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk('next', { target = 'all' })
      end
    end

    local function prev_hunk()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk('prev', { target = 'all' })
      end
    end

    local function map(mode, keys, callback)
      vim.keymap.set(mode, keys, callback,  { buffer = bufnr })
    end

    map('n', '<C-n>', next_hunk)
    map('n', '<C-p>', prev_hunk)

    map('n', '<Leader>hp', gitsigns.preview_hunk_inline)
    map('n', '<Leader>hs', gitsigns.stage_hunk)
    map('n', '<Leader>hS', gitsigns.stage_buffer)
    map('x', '<Leader>hs', function()
      gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end)
    map('n', '<Leader>hu', gitsigns.reset_hunk)
    map('x', '<Leader>hu', function()
      gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end)
    map('n', '<Leader>hd', function() vim.cmd.tabnew'%'; gitsigns.diffthis() end)
    map('n', '<Leader>hb', function() gitsigns.blame_line { full = true } end)
    map('n', '<Leader>hB', gitsigns.blame)
  end
}
vim.keymap.set('n', '<Leader>hq', function()
  gitsigns.setqflist('all', { open = false }, function() vim.cmd'cfirst' end)
end)

vim.o.statusline = '%<%f %-12.(%h%w%m%r%) %{get(b:,"gitsigns_status","")}%=%-14.(%l,%c%V%) %P'

function is_git()
  return vim.fs.find('.git', { upward = true })[1] ~= nil
end

function git_anchor()
  if not is_git() then return nil end
  anchor = vim.system { 'git', 'feature-base' }:wait().stdout:gsub('%s+', '')
  gitsigns.change_base(anchor)
  return anchor
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
vim.o.signcolumn = 'yes'

vim.o.list = true
vim.o.listchars = 'trail:•,tab:┃ ,nbsp:␣,extends:›,precedes:‹'
vim.o.fillchars = 'vert: '
vim.o.breakindent = true
vim.o.showbreak = ' ↪ '
vim.o.termguicolors = true

vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 72
vim.o.formatoptions = 'jcrql2or/'

vim.o.winminheight = 0
vim.o.winminwidth = 0

vim.o.softtabstop = -1
vim.o.shiftwidth = 2
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

vim.o.grepprg = 'rg --vimgrep --no-ignore --hidden --follow'
vim.o.diffopt = 'internal,filler,algorithm:patience,indent-heuristic,vertical,closeoff,iwhite,iwhiteeol'

vim.keymap.set('i', '<C-y>', '<C-r>"')
vim.keymap.set('i', '<C-l>', '<C-x><C-l>')

vim.keymap.set('i', '<C-Space>', '<Right>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-e>', '<C-Right>')
vim.keymap.set('i', '<C-t>', '<C-Left>')
vim.keymap.set('i', '<C-d>', '<Delete>')
vim.keymap.set('i', '<C-a>', '<Home>')
vim.keymap.set('i', '<C-g><C-n>', '<C-g>j')
vim.keymap.set('i', '<C-g><C-p>', '<C-g>k')

vim.keymap.set('c', '<C-Space>', '<Right>')
vim.keymap.set('c', '<C-h>', '<Left>')
vim.keymap.set('c', '<C-e>', '<C-Right>')
vim.keymap.set('c', '<C-t>', '<C-Left>')
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-o>', '<End>')

vim.keymap.set('', ',', ':')
vim.keymap.set('n', 'a', 'i')
vim.keymap.set('', 'A', 'I')
vim.keymap.set('n', 'i', 'a')
vim.keymap.set('', 'I', 'A')
vim.keymap.set('', '<C-a>', '^')
vim.keymap.set('', '<C-o>', '$')
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
vim.keymap.set('', 'go', 'ge')
vim.keymap.set('', 'gO', 'gE')
vim.keymap.set('', '\\', '<C-^>')
vim.keymap.set('', 'j', 'J')
vim.keymap.set('', 'J', 'gJ')
vim.keymap.set('', 'ZA', ':q<CR>')
vim.keymap.set('', 'ZT', ':tabclose<CR>')
vim.keymap.set('', '<BS>', '<Nop>')
vim.keymap.set('', '<C-d>', '<C-i>')
vim.keymap.set('', '<C-u>', '<C-o>')
vim.keymap.set('', '<C-g>', 'g<C-g>')
vim.keymap.set('', 'c', 'o')
vim.keymap.set('', 'C', 'O')
vim.keymap.set('', '<C-c>', '<C-a>')
vim.keymap.set('', 'g<C-c>', 'g<C-a>')
vim.keymap.set('n', 'gh', 'gk', { desc = 'Up [count] display lines' })
vim.keymap.set('n', 'g<Space>', 'gj', { desc = 'Down [count] display lines' })
vim.keymap.set('', 'gz', '1z=')
vim.keymap.set('', '+', '?')
vim.keymap.set('', '<C-q>', '<C-y>')
vim.keymap.set('', '<C-y>', '<C-e>')
vim.keymap.set('', 'b', 't')
vim.keymap.set('', 'B', 'T')
vim.keymap.set('', 'gH', 'H')
vim.keymap.set('', 'gM', 'M')
vim.keymap.set('', 'gL', 'L')
vim.keymap.set('', '<C-w><C-l>', '<C-w>s')
vim.keymap.set('', '<C-w>l', '<C-w>s')
vim.keymap.set('n', '-', "<Cmd>normal! m'<CR><Cmd>Explore<CR>")
vim.keymap.set('n', '_', '<Cmd>SmartFileSwitch<CR>', { silent = true })
vim.keymap.set('n', '[[', function()
  require'treesitter-context'.go_to_context(vim.v.count1)
end, { silent = true })

vim.keymap.set('n', 'l', '<Plug>(MatchitNormalForward)')
vim.keymap.set('x', 'l', '<Plug>(MatchitVisualForward)')
vim.keymap.set('o', 'l', '<Plug>(MatchitOperationForward)')
vim.keymap.set('n', 'L', '<Plug>(MatchitNormalBackward)')
vim.keymap.set('x', 'L', '<Plug>(MatchitVisualBackward)')
vim.keymap.set('o', 'L', '<Plug>(MatchitOperationBackward)')
vim.keymap.set('x', 'al', '<Plug>(MatchitVisualTextObject)')

vim.keymap.set('n', '<Leader>e', FzfLua.files)
vim.keymap.set('n', '<Leader>f', FzfLua.blines)
vim.keymap.set('n', '<Leader>a', FzfLua.live_grep)
vim.keymap.set('n', '<Leader>A', function() FzfLua.live_grep { cwd = vim.fn.expand('%:p:h') } end)
vim.keymap.set('n', '<Leader>t', function() FzfLua.grep { search = 'TODO' } end)
vim.keymap.set('n', '<Leader>*', FzfLua.grep_cword)
vim.keymap.set('n', '<Leader>o', FzfLua.buffers)
vim.keymap.set('n', '<Leader>q', FzfLua.quickfix)
vim.keymap.set('n', "<Leader>'", FzfLua.marks)
vim.keymap.set('n', '<Leader>j', FzfLua.jumps)
vim.keymap.set('n', '<Leader>r', FzfLua.resume)
vim.keymap.set('n', '<Leader>R', FzfLua.oldfiles)
vim.keymap.set('n', '<Leader>m', function() FzfLua.git_diff { ref = git_anchor() } end)
vim.keymap.set('n', '<Leader>H', function() FzfLua.git_hunks { ref = git_anchor() } end)
vim.keymap.set('n', '<Leader>k', FzfLua.keymaps)
vim.keymap.set('n', '<Leader>,', FzfLua.commands)

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

vim.api.nvim_create_user_command('SmartFileSwitch', function()
  current_file = vim.fn.expand('%')
  complement_suffixes = {
    { '.cpp', '.h' },
    { '.c', '.h' },
    { '.h', '.c' },
    { '.h', '.cpp' },
    { '.mli', '.ml' },
    { '.ml', '.mli' },
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

vim.g.man_hardwrap = 1

vim.filetype.add {
  extension = {
    asy = 'cpp',
    sage = 'python'
  }
}

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
vim.api.nvim_create_autocmd('FileType', { pattern = 'plaintex', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'tex', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'text', command = 'setl fo+=t' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'man', command = 'setl nospell' })
vim.api.nvim_create_autocmd('FileType', { pattern = 'netrw',
  callback = function()
    vim.keymap.set('n', 't', 'b', { buffer = true, silent = true })
    -- vim.keymap.set('n', '-', "<Cmd>normal! m'<CR><Plug>NetrwBrowseDirUp<CR>", { buffer = true, silent = true })
  end,
})

-- vim.lsp.enable('phpactor')
