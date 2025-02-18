return {
  'RedsXDD/neopywal.nvim',
  name = 'neopywal',
  lazy = false,
  priority = 1000,
  opts = {
    use_palette = 'wallust',
    transparent_background = true,
  },
  init = function()
    vim.cmd.colorscheme 'neopywal-dark'
  end,
}
