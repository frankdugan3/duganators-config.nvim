vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
    notify = true,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
