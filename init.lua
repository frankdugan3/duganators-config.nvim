local config_file = vim.fn.stdpath 'config' .. '/init.lua'
local tab_width = 2
local leader = ' '
local g = vim.g
local o = vim.opt

local api = vim.api
api.nvim_create_autocmd('BufWritePost', {
  desc = 'Reload config on save',
  group = api.nvim_create_augroup('ConfigReload', { clear = true }),
  pattern = config_file,
  callback = function()
    vim.cmd('silent! source ' .. config_file)
    vim.schedule(function()
      vim.notify('Config reloaded!', vim.log.levels.INFO)
    end)
  end,
})

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = api.nvim_create_augroup('HighlightYank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

api.nvim_create_autocmd('VimEnter', {
  desc = 'Open Telescope when starting in directory',
  pattern = { '*/', '.' },
  callback = function()
    if vim.fn.isdirectory(vim.fn.getcwd()) == 1 then
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
o.virtualedit = 'block'
o.wrap = true

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end

-- Add lazy to the `runtimepath`, this allows us to `require` it
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load the `lua/plugins/` folder
require('lazy').setup({ import = 'plugins' }, {
  change_detection = {
    enabled = true,
    notify = false,
  },
})

local set = vim.keymap.set
local tsb = require 'telescope.builtin'
local which_key = require 'which-key'

-- Hide highlighted search on enter or Esc
set('n', '<Esc>', '<cmd>nohlsearch<CR>')
set('n', '<CR>', function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ''
  else
    return '<CR>'
  end
end, { expr = true })

set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Basic window split movement keybinds
set({ 'n', 'v' }, '<C-j>', '<C-w><C-j>')
set({ 'n', 'v' }, '<C-k>', '<C-w><C-k>')
set({ 'n', 'v' }, '<C-l>', '<C-w><C-l>')
set({ 'n', 'v' }, '<C-h>', '<C-w><C-h>')
set('i', '<C-j>', '<Esc><C-w><C-j>')
set('i', '<C-k>', '<Esc><C-w><C-k>')
set('i', '<C-l>', '<Esc><C-w><C-l>')
set('i', '<C-h>', '<Esc><C-w><C-h>')

-- Center screen when jumping
set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Better indenting in visual mode
set('v', '<', '<gv', { desc = 'Indent left and reselect' })
set('v', '>', '>gv', { desc = 'Indent right and reselect' })

set('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Go to previous [D]iagnostic message' })
set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })

which_key.add { '<leader>b', group = '[b]uffer' }
set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[d]elete (close) current buffer' })
set('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'Force [D]elete (close) current buffer' })
set('n', '<leader>bs', tsb.buffers, { desc = '[s]earch existing buffers' })
