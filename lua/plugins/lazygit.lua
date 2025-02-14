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
    { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current [F]ile' },
    { '<leader>gr', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit [R]eflog' },
    { '<leader>gb', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit [B]uffer Reflog' },
  },
}
