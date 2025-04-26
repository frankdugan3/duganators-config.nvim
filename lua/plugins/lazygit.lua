return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gl', '<cmd>LazyGit<cr>', desc = '[L]azyGit' },
    { '<leader>gr', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit [R]eflog' },
    { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current [F]ile' },
    { '<leader>gb', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit Current File Reflog' },
  },
}
