return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'css',
      'diff',
      'dockerfile',
      'eex',
      'elixir',
      'gitignore',
      'go',
      'heex',
      'html',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'rust',
      'toml',
      -- 'typsecript',
      'vim',
      'vimdoc',
      'yaml',
      'zig',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end,
}
