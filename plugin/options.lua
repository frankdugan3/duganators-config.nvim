local opt = vim.opt
local g = vim.g

opt.backupcopy = 'yes'

opt.inccommand = 'split'

opt.smartcase = true
opt.ignorecase = true

g.have_nerd_font = true
opt.mouse = 'a'
opt.showmode = false

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 10

opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.splitbelow = true
opt.splitright = true

opt.hlsearch = true

opt.signcolumn = 'yes'
opt.shada = { "'10", '<0', 's10', 'h' }

opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true

-- Don't have `o` add a comment
opt.formatoptions:remove 'o'
