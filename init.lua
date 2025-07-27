local config_file = vim.fn.stdpath 'config' .. '/init.lua'
local tab_width = 2
local leader = ' '

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

local g = vim.g
g.mapleader = leader
g.maplocalleader = leader
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.have_nerd_font = true

local o = vim.opt
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
