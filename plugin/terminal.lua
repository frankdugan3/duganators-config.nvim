local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
  end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set('t', '<C-Esc>', '<c-\\><c-n>')

-- Easy navigation from terminals
vim.keymap.set('t', '<c-h>', '<c-\\><c-n><c-w>h')
vim.keymap.set('t', '<c-j>', '<c-\\><c-n><c-w>j')
vim.keymap.set('t', '<c-k>', '<c-\\><c-n><c-w>k')
vim.keymap.set('t', '<c-l>', '<c-\\><c-n><c-w>l')

local terminal_windows = {
  ['H'] = { win = nil, buf = nil },
  ['J'] = { win = nil, buf = nil },
  ['K'] = { win = nil, buf = nil },
  ['L'] = { win = nil, buf = nil },
}

local function toggle_terminal(direction)
  local state = terminal_windows[direction]

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = nil
  else
    vim.cmd.new()
    vim.cmd.wincmd(direction)
    if direction == 'H' or direction == 'L' then
      vim.api.nvim_win_set_width(0, 80)
      vim.api.nvim_win_set_option(0, 'winfixwidth', true)
    else
      vim.api.nvim_win_set_height(0, 12)
      vim.api.nvim_win_set_option(0, 'winfixheight', true)
    end

    state.win = vim.api.nvim_get_current_win()

    if state.buf and vim.api.nvim_buf_is_loaded(state.buf) then
      vim.api.nvim_win_set_buf(state.win, state.buf)
    else
      vim.cmd.term()
      state.buf = vim.api.nvim_win_get_buf(state.win)
    end
  end
end

local allModes = { 'n', 'i', 'v', 't' }
vim.keymap.set(allModes, '<C-S-h>', function()
  toggle_terminal 'H'
end)

vim.keymap.set(allModes, '<C-S-j>', function()
  toggle_terminal 'J'
end)

vim.keymap.set(allModes, '<C-S-k>', function()
  toggle_terminal 'K'
end)

vim.keymap.set(allModes, '<C-S-l>', function()
  toggle_terminal 'L'
end)
