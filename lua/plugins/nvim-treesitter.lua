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
      'javascript',
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
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

    parser_config.ziggy = {
      install_info = {
        url = 'https://github.com/kristoff-it/ziggy',
        includes = { 'tree-sitter-ziggy/src' },
        files = { 'tree-sitter-ziggy/src/parser.c' },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'ziggy',
    }

    parser_config.ziggy_schema = {
      install_info = {
        url = 'https://github.com/kristoff-it/ziggy',
        files = { 'tree-sitter-ziggy-schema/src/parser.c' },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'ziggy-schema',
    }

    parser_config.supermd = {
      install_info = {
        url = 'https://github.com/kristoff-it/supermd',
        includes = { 'tree-sitter/supermd/src' },
        files = {
          'tree-sitter/supermd/src/parser.c',
          'tree-sitter/supermd/src/scanner.c',
        },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'supermd',
    }

    parser_config.supermd_inline = {
      install_info = {
        url = 'https://github.com/kristoff-it/supermd',
        includes = { 'tree-sitter/supermd-inline/src' },
        files = {
          'tree-sitter/supermd-inline/src/parser.c',
          'tree-sitter/supermd-inline/src/scanner.c',
        },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'supermd_inline',
    }

    parser_config.superhtml = {
      install_info = {
        url = 'https://github.com/kristoff-it/superhtml',
        includes = { 'tree-sitter-superhtml/src' },
        files = {
          'tree-sitter-superhtml/src/parser.c',
          'tree-sitter-superhtml/src/scanner.c',
        },
        branch = 'main',
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
      },
      filetype = 'superhtml',
    }

    vim.filetype.add {
      extension = {
        smd = 'supermd',
        shtml = 'superhtml',
        ziggy = 'ziggy',
        ['ziggy-schema'] = 'ziggy_schema',
      },
    }

    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
  end,
}
