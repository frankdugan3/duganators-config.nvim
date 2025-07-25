-- NOTE: This configuration depends on Neovim v0.12 (unreleased, use nightly)

local api = vim.api
local g = vim.g
local o = vim.opt
local cmd = vim.cmd
local fn = vim.fn
-- local lsp = vim.lsp

local config_file = fn.expand("~") .. "/.config/nvim/simple_init.lua"
local wallust_file = fn.expand("~") .. "/.cache/wallust/colors_neopywal.vim"
local tab_width = 2
local leader = ' '


-- HACK: This is only needed while starting with --clean
o.packpath = fn.stdpath('data') .. '/site,' .. vim.env.VIMRUNTIME

local function reload_config()
  cmd("silent! source " .. config_file)
  vim.schedule(function() vim.notify("Config reloaded!", vim.log.levels.INFO) end)
end

api.nvim_create_autocmd("BufWritePost", {
  desc = "Reload config on save",
  group = api.nvim_create_augroup("ConfigReload", { clear = true }),
  pattern = config_file,
  callback = reload_config,
})

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = api.nvim_create_augroup('HighlightYank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

api.nvim_create_autocmd('VimEnter', {
  desc = 'Open Telescope when starting in directory',
  pattern = { '*/', '.' },
  callback = function()
    if fn.isdirectory(fn.getcwd()) == 1 then
      require('telescope.builtin').find_files()
    end
  end,
})

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
o.virtualedit = "block"
o.wrap = true

vim.diagnostic.config({
  virtual_lines = true,
})

if vim.loop.fs_stat(wallust_file) then
  vim.pack.add({ "https://github.com/RedsXDD/neopywal.nvim" })
  require("neopywal").setup({
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
    }
  })
  cmd.colorscheme 'neopywal-dark'
else
  cmd.colorscheme 'default'
end

vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mikavilpas/yazi.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  { src = "https://github.com/saghen/blink.cmp", version = "v1.6.0" },
})

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
require("todo-comments").setup({})
require("telescope").setup({
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  }
})
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
local tsb = require 'telescope.builtin'

require("mason").setup()
require("mason-lspconfig").setup()

require("blink.cmp").setup({
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = { download = true },
  }
})

local which_key = require('which-key')
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

-- Basic window split movement keybinds
set({ 'n', 'v' }, '<C-j>', '<C-w><C-j>')
set({ 'n', 'v' }, '<C-k>', '<C-w><C-k>')
set({ 'n', 'v' }, '<C-l>', '<C-w><C-l>')
set({ 'n', 'v' }, '<C-h>', '<C-w><C-h>')
set('i', '<C-j>', '<Esc><C-w><C-j>')
set('i', '<C-k>', '<Esc><C-w><C-k>')
set('i', '<C-l>', '<Esc><C-w><C-l>')
set('i', '<C-h>', '<Esc><C-w><C-h>')

set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })
set('n', '[d', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Go to previous [D]iagnostic message' })
set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end,
  { desc = 'Go to next [D]iagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
set('n', '<leader>f', function() require('conform').format { lsp_format = "fallback" } end,
  { desc = '[F]ormat current file' })

which_key.add { '<leader>g', group = '[G]it' }
set('n', '<leader>gl', '<cmd>LazyGit<cr>', { desc = '[L]azyGit' })
set('n', '<leader>gr', '<cmd>LazyGitFilter<cr>', { desc = 'LazyGit [R]eflog' })
set('n', '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', { desc = 'LazyGit Current [F]ile' })
set('n', '<leader>gb', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = 'LazyGit Current File Reflog' })

set('n', '<leader>\\', '<cmd>Yazi<cr>', { desc = 'Open yazi at the current file', })
set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = "Open the file manager in nvim's working directory", })
set('n', '<c-up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume the last yazi session', })

which_key.add { '<leader>s', group = '[S]earch' }
set('n', '<leader>sh', tsb.help_tags, { desc = 'Search [h]elp' })
set('n', '<leader>sk', tsb.keymaps, { desc = 'Search [k]eymaps' })
set('n', '<leader>sf', tsb.find_files, { desc = 'Search [f]iles' })
set('n', '<leader>ss', tsb.builtin, { desc = 'Search [s]elect Telescope' })
set('n', '<leader>sw', tsb.grep_string, { desc = 'Search current [w]ord' })
set('n', '<leader>sg', tsb.live_grep, { desc = 'Search via [g]rep' })
set('n', '<leader>sd', tsb.diagnostics, { desc = 'Search [d]iagnostics' })
set('n', '<leader>sr', tsb.resume, { desc = 'Search [r]esume' })
set('n', '<leader>s.', tsb.oldfiles, { desc = 'Search recent files ("." for repeat)' })
set('n', '<leader>sb', tsb.buffers, { desc = 'Search existing [b]uffers' })

set('n', '<leader>/', function()
  tsb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

set('n', '<leader>s/', function()
  tsb.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

which_key.add { '<leader>n', group = '[N]eovim' }
which_key.add { '<leader>ns', group = '[S]earch' }
set('n', '<leader>nr', reload_config, { desc = '[R]eload the config' })
set('n', '<leader>nu', function()
  vim.pack.update(nil, { force = true })
  cmd('MasonUpdate')
end, { desc = '[U]pdate plugins and tools' })
set('n', '<leader>nm', '<cmd>Mason<cr>', { desc = 'Show [M]ason' })
set('n', '<leader>nsf', function() tsb.find_files { cwd = fn.stdpath 'config' } end, { desc = 'Search Neovim [f]iles' })
set('n', '<leader>nsg', function() tsb.live_grep { cwd = fn.stdpath 'config' } end, { desc = 'Search Neovim via [g]rep' })
