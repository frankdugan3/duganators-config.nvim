return {
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = 'dark',
      floats = 'dark',
    },
    init = function()
      vim.cmd.colorscheme 'moonfly'
      vim.cmd.hi 'Comment gui=none'
      vim.g.moonflyItalics = true
    end,
  },
}
-- return {
--   {
--     'dasupradyumna/midnight.nvim',
--     lazy = false,
--     priority = 1000,
--     terminal_colors = true,
--     styles = {
--       comments = { italic = true },
--       keywords = { italic = true },
--       functions = {},
--       variables = {},
--       sidebars = 'dark',
--       floats = 'dark',
--     },
--     init = function()
--       vim.cmd.colorscheme 'midnight'
--       vim.cmd.hi 'Comment gui=none'
--     end,
--   },
-- }
-- return {
--   'folke/tokyonight.nvim',
--   priority = 1000,
--   terminal_colors = true,
--   styles = {
--     comments = { italic = true },
--     keywords = { italic = true },
--     functions = {},
--     variables = {},
--     sidebars = 'dark',
--     floats = 'dark',
--   },
--   init = function()
--     vim.cmd.colorscheme 'tokyonight-night'
--     vim.cmd.hi 'Comment gui=none'
--   end,
-- }
