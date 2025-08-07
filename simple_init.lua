-- NOTE: This configuration depends on Neovim v0.12 (unreleased, use nightly)

local api = vim.api
local g = vim.g
local o = vim.opt
local cmd = vim.cmd
local fn = vim.fn
-- local lsp = vim.lsp

local config_file = debug.getinfo(1, 'S').source:match '@(.*)'
local wallust_file = os.getenv 'HOME' .. '/.cache/wallust/colors_neopywal.vim'
local tab_width = 2
local leader = ' '

-- HACK: This is only needed while starting with --clean
o.packpath = fn.stdpath 'data' .. '/site,' .. vim.env.VIMRUNTIME

local function reload_config()
  cmd('silent! source ' .. config_file)
  vim.schedule(function()
    vim.notify('Config reloaded!', vim.log.levels.INFO)
  end)
end

local function update_all_mason_packages()
  cmd 'MasonUpdate'
  local registry = require 'mason-registry'
  local installed_packages = registry.get_installed_package_names()

  for _, pkg_name in ipairs(installed_packages) do
    local pkg = registry.get_package(pkg_name)
    local is_installed, installed_version = pcall(pkg.get_installed_version, pkg)
    local is_latest, latest_version = pcall(pkg.get_latest_version, pkg)

    if is_installed and is_latest and installed_version ~= latest_version then
      pkg:install()
    end
  end
end

local function get_chezmoi_source_dir()
  local handle = io.popen 'chezmoi source-path'
  if handle then
    local result = handle:read('*a'):gsub('%s+$', '')
    handle:close()
    return result
  end
  return nil
end

api.nvim_create_autocmd('BufWritePost', {
  desc = 'Reload config on save',
  group = api.nvim_create_augroup('ConfigReload', { clear = true }),
  pattern = config_file,
  callback = reload_config,
})

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = api.nvim_create_augroup('HighlightYank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

api.nvim_create_autocmd('VimEnter', {
  desc = 'Open FzfLua when starting in directory',
  pattern = { '*/', '.' },
  callback = function()
    if fn.isdirectory(fn.getcwd()) == 1 then
      require('fzf-lua').files()
    end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  command = 'lua require("fzf-lua").redraw()',
})

local chezmoi_source_dir = get_chezmoi_source_dir()
if chezmoi_source_dir then
  vim.api.nvim_create_augroup('ChezmoiAutoApply', { clear = true })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'ChezmoiAutoApply',
    pattern = chezmoi_source_dir .. '/*',
    callback = function()
      local file_path = vim.fn.expand '%:p'
      local relative_path = file_path:gsub('^' .. vim.pesc(chezmoi_source_dir) .. '/', '')

      vim.fn.jobstart({ 'chezmoi', 'apply', '--source-path', file_path }, {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify('Chezmoi applied: ' .. relative_path, vim.log.levels.INFO)
          else
            vim.notify('Chezmoi apply failed for: ' .. relative_path, vim.log.levels.ERROR)
          end
        end,
        stdout_buffered = true,
        stderr_buffered = true,
      })
    end,
    desc = 'Auto-apply chezmoi changes on save',
  })
else
  vim.notify('Could not determine chezmoi source directory', vim.log.levels.WARN)
end

g.mapleader = leader
g.maplocalleader = leader
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.have_nerd_font = true

o.backupcopy = 'yes'
o.breakindent = true
o.clipboard = 'unnamedplus'
o.cursorline = true
o.expandtab = true
o.formatoptions:remove 'o'
o.hlsearch = true
o.ignorecase = true
o.inccommand = 'split'
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.mouse = 'a'
o.number = true
o.relativenumber = true
o.scrolloff = 10
o.shada = { "'10", '<0', 's10', 'h' }
o.shiftwidth = tab_width
o.showmode = true
o.signcolumn = 'yes'
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.tabstop = tab_width
o.termguicolors = true
o.undofile = true
o.virtualedit = 'block'
o.winborder = 'rounded'
o.wrap = true

vim.diagnostic.config {
  virtual_lines = true,
}

if vim.loop.fs_stat(wallust_file) then
  vim.pack.add { 'https://github.com/RedsXDD/neopywal.nvim' }
  require('neopywal').setup {
    use_palette = 'wallust',
    terminal_colors = true,
    transparent_background = true,
    styles = {
      comments = { 'italic' },
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      includes = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      types = {},
      operators = {},
    },
  }
  cmd.colorscheme 'neopywal-dark'
else
  cmd.colorscheme 'default'
end

vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/MagicDuck/grug-far.nvim',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mikavilpas/yazi.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/conform.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.6.0' },
}

require('conform').setup {
  notify_on_error = false,
  format_on_save = function()
    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,
  formatters = {
    superhtml = {
      inherit = false,
      command = 'superhtml',
      stdin = true,
      args = { 'fmt', '--stdin-super' },
    },
    ziggy = {
      inherit = false,
      command = 'ziggy',
      stdin = true,
      args = { 'fmt', '--stdin' },
    },
    ziggy_schema = {
      inherit = false,
      command = 'ziggy',
      stdin = true,
      args = { 'fmt', '--stdin-schema' },
    },
  },
  formatters_by_ft = {
    sh = { 'shfmt' },
    templ = { 'templ' },
    go = { 'goimports', 'gofmt' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    typst = { 'tinymist' },
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier' },
    markdown = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
    shtml = { 'superhtml' },
    ziggy = { 'ziggy' },
    ziggy_schema = { 'ziggy_schema' },
  },
}

local fzf = require 'fzf-lua'
fzf.setup {
  fzf_colors = { true, bg = '-1', gutter = '-1' },
  actions = {
    files = {
      ['default'] = fzf.actions.file_edit,
      ['ctrl-d'] = fzf.actions.preview_page_down,
      ['ctrl-u'] = fzf.actions.preview_page_up,
      ['ctrl-s'] = fzf.actions.file_split,
      ['ctrl-v'] = fzf.actions.file_vsplit,
      ['ctrl-q'] = fzf.actions.file_sel_to_qf,
    },
    grep = {
      ['default'] = fzf.actions.file_edit,
      ['ctrl-d'] = fzf.actions.preview_page_down,
      ['ctrl-u'] = fzf.actions.preview_page_up,
      ['ctrl-s'] = fzf.actions.file_split,
      ['ctrl-v'] = fzf.actions.file_vsplit,
      ['ctrl-q'] = fzf.actions.file_sel_to_qf,
    },
  },
}

require('grug-far').setup { windowCreationCommand = 'edit' }

require('mini.ai').setup { n_lines = 500 }
require('mini.statusline').setup { use_icons = g.have_nerd_font }
require('mini.surround').setup {
  custom_surroundings = { e = { output = { left = '<%= ', right = ' %>' } } },
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    replace = 'gsr',
    update_n_lines = 'gsn',
  },
}
require('todo-comments').setup {}
require('mason').setup()
require('mason-lspconfig').setup()

require('blink.cmp').setup {
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = { download = true },
  },
}

local which_key = require 'which-key'
which_key.setup()

local set = vim.keymap.set

-- Hide highlighted search on enter or Esc
set('n', '<Esc>', '<cmd>nohlsearch<CR>')
set('n', '<CR>', function()
  if vim.v.hlsearch == 1 then
    cmd.nohl()
    return ''
  else
    return '<CR>'
  end
end, { expr = true })

set('', '<C-s>', '<cmd>w<cr>', { desc = 'Save (:w)' })
set('', '<CS-s>', '<cmd>wa<cr>', { desc = 'Save all (:wa)' })

-- Basic window split movement keybinds
set({ 'n', 'v' }, '<C-j>', '<C-w><C-j>')
set({ 'n', 'v' }, '<C-k>', '<C-w><C-k>')
set({ 'n', 'v' }, '<C-l>', '<C-w><C-l>')
set({ 'n', 'v' }, '<C-h>', '<C-w><C-h>')
set('i', '<C-j>', '<Esc><C-w><C-j>')
set('i', '<C-k>', '<Esc><C-w><C-k>')
set('i', '<C-l>', '<Esc><C-w><C-l>')
set('i', '<C-h>', '<Esc><C-w><C-h>')

set('v', '<', '<gv', { desc = 'Dedent and reselect' })
set('v', '>', '>gv', { desc = 'Indent and reselect' })

set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })
set('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Go to previous [D]iagnostic message' })
set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
set('n', '<leader>f', function()
  require('conform').format { lsp_format = 'fallback' }
end, { desc = '[F]ormat current file' })

which_key.add { '<leader>b', group = '[b]uffer' }
set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[d]elete (close) current buffer' })
set('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'force [d]elete (close) current buffer' })
set('n', '<leader>bs', '<cmd>FzfLua buffers<cr>', { desc = '[s]earch existing buffers' })

which_key.add { '<leader>g', group = '[g]it' }
set('n', '<leader>gl', '<cmd>LazyGit<cr>', { desc = '[l]azygit' })
set('n', '<leader>gr', '<cmd>LazyGitFilter<cr>', { desc = 'lazygit [r]eflog' })
set('n', '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', { desc = 'lazygit current [f]ile' })
set('n', '<leader>gc', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = 'lazygit [c]urrent file reflog' })

set('n', '<leader>\\', '<cmd>Yazi<cr>', { desc = 'open yazi at the current file' })
set('n', '<c-up>', '<cmd>Yazi toggle<cr>', { desc = 'resume the last yazi session' })

which_key.add { '<leader>s', group = '[S]earch' }
set('n', '<leader>sk', '<cmd>FzfLua keymaps<cr>', { desc = 'search [k]eymaps' })
set('n', '<leader>sh', '<cmd>FzfLua help_tags<cr>', { desc = 'search [h]elp' })
set('n', '<leader>sf', '<cmd>FzfLua files<cr>', { desc = 'search [f]iles' })
set('n', '<leader>sz', '<cmd>FzfLua builtin<cr>', { desc = 'search f[z]f lua builtins' })
set('n', '<leader>sw', '<cmd>FzfLua grep_cword<cr>', { desc = 'search current [w]ord' })
set('n', '<leader>sg', '<cmd>FzfLua live_grep<cr>', { desc = 'search via [g]rep' })
set('n', '<leader>sd', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'search [d]iagnostics' })
set('n', '<leader>sr', '<cmd>FzfLua resume<cr>', { desc = 'search [r]esume' })
set('n', '<leader>s.', '<cmd>FzfLua oldfiles<cr>', { desc = 'search recent files ("." for repeat)' })
set('n', '<leader>sb', '<cmd>FzfLua buffers<cr>', { desc = 'search existing [b]uffers' })

which_key.add { '<leader>r', group = '[r]eplace' }

set({ 'n', 'x' }, '<leader>rv', function()
  require('grug-far').open { transient = true, visualSelectionUsage = 'operate-within-range' }
end, { desc = 'replace within [v]isual range' })

set('n', '<leader>rb', function()
  require('grug-far').open { transient = true, prefills = { paths = vim.fn.expand '%' } }
end, { desc = 'replace within [b]uffer' })

set('n', '<leader>rp', function()
  require('grug-far').open { transient = true }
end, { desc = 'replace within [p]roject' })

set({ 'n', 'x' }, '<leader>rs', function()
  local search = vim.fn.getreg '/'
  if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
    search = '\\b' .. search:sub(3, -3) .. '\\b'
  end
  require('grug-far').open { transient = true, prefills = { search = search } }
end, { desc = 'replace using @/ register value or visual selection' })

which_key.add { '<leader>d', group = '[d]otfiles' }

set('n', '<leader>dc', function()
  require('yazi').yazi(nil, os.getenv 'XDG_CONFIG_HOME')
end, { desc = 'Open Yazi in $XDG_CONFIG_HOME' })

set('n', '<leader>db', function()
  require('yazi').yazi(nil, os.getenv 'HOME' .. '/.local/bin')
end, { desc = 'Open Yazi in $HOME/.local/[b]in' })

set('n', '<leader>ds', function()
  fzf.fzf_exec('chezmoi managed --no-pager --path-style source-absolute', {
    previewer = 'builtin',
    actions = fzf.defaults.actions.files,
  })
end, { desc = '[s]earch chezmoi-managed dotfiles' })

set('n', '<leader>dg', function()
  local managed_files = vim.fn.systemlist 'chezmoi managed --no-pager --path-style source-absolute'

  fzf.live_grep {
    filespec = table.concat(managed_files, ' '),
    actions = fzf.defaults.actions.files,
  }
end, { desc = '[g]rep chezmoi-managed dotfiles' })
vim.keymap.set('n', '<leader>dl', function()
  require('lazygit').lazygit(get_chezmoi_source_dir())
end, { desc = '[l]azygit for chezmoi-managed dotfiles' })
set('n', '<leader>/', '<cmd>FzfLua blines<cr>', { desc = '[/] Fuzzily search in current buffer' })

set('n', '<leader>s/', function()
  fzf.live_grep { filespec = table.concat(vim.tbl_map(vim.api.nvim_buf_get_name, vim.api.nvim_list_bufs()), ' ') }
end, { desc = '[S]earch [/] in Open Files' })

which_key.add { '<leader>n', group = '[n]eovim' }

set('n', '<leader>nr', reload_config, { desc = 'neovim [r]eload config' })

set('n', '<leader>nu', function()
  vim.pack.update(nil, { force = true })
  update_all_mason_packages()
end, { desc = 'neovim [u]pdate plugins and tools' })

set('n', '<leader>nm', '<cmd>Mason<cr>', { desc = 'neovim [m]ason' })

which_key.add { '<leader>ns', group = '[s]earch' }

set('n', '<leader>nsf', function()
  fzf.files { cwd = fn.stdpath 'config' }
end, { desc = 'neovim search [f]iles' })

set('n', '<leader>nsg', function()
  fzf.live_grep { cwd = fn.stdpath 'config' }
end, { desc = 'neovim search [g]rep' })
