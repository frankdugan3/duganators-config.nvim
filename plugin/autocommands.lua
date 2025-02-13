local api = vim.api

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

api.nvim_create_autocmd('VimEnter', {
  pattern = { '*/', '.' },
  callback = function()
    if vim.fn.isdirectory(vim.fn.getcwd()) == 1 then
      require('telescope.builtin').find_files()
    end
  end,
})
