return {
  'NStefan002/screenkey.nvim',
  cmd = 'Screenkey',
  version = '*',
  opts = {
    win_opts = {
      row = vim.o.lines - vim.o.cmdheight - 1,
      col = vim.o.columns - 1,
      relative = 'editor',
      anchor = 'SE',
      width = 40,
      height = 1,
      border = 'single',
    },
    compress_after = 3,
    clear_after = 3,
    disable = {
      filetypes = {},
      buftypes = {},
    },
    group_mappings = false,
    show_leader = true,
    keys = {
      ['<TAB>'] = '󰌒',
      ['<CR>'] = '↩',
      ['<ESC>'] = '⎋',
      ['<SPACE>'] = '␣',
      ['<BS>'] = '⌫',
      ['<DEL>'] = '⌦',
      ['<LEFT>'] = '',
      ['<RIGHT>'] = '',
      ['<UP>'] = '',
      ['<DOWN>'] = '',
      ['<HOME>'] = 'Home',
      ['<END>'] = 'End',
      ['<PAGEUP>'] = 'PgUp',
      ['<PAGEDOWN>'] = 'PgDn',
      ['<INSERT>'] = 'Ins',
      ['<F1>'] = '󱊫',
      ['<F2>'] = '󱊬',
      ['<F3>'] = '󱊭',
      ['<F4>'] = '󱊮',
      ['<F5>'] = '󱊯',
      ['<F6>'] = '󱊰',
      ['<F7>'] = '󱊱',
      ['<F8>'] = '󱊲',
      ['<F9>'] = '󱊳',
      ['<F10>'] = '󱊴',
      ['<F11>'] = '󱊵',
      ['<F12>'] = '󱊶',
      ['CTRL'] = '⌃',
      ['ALT'] = '⌥',
      ['SUPER'] = '󰘳',
    },
  },
}