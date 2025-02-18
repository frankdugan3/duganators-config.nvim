return {
  'RedsXDD/neopywal.nvim',
  name = 'neopywal',
  lazy = false,
  priority = 1000,
  opts = {
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
  },
  init = function()
    vim.cmd.colorscheme 'neopywal-dark'
  end,
}
