local set = vim.keymap.set

-- Hide highlighted search on enter or Esc
set('n', '<Esc>', '<cmd>nohlsearch<CR>')
set('n', '<CR>', function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ''
  else
    return '<CR>'
  end
end, { expr = true })

-- Basic window split movement keybinds
set({ 'n', 'v' }, '<C-j>', '<C-w><C-j>')
set({ 'n', 'v' }, '<C-k>', '<C-w><C-k>')
set({ 'n', 'v' }, '<C-l>', '<C-w><C-l>')
set({ 'n', 'v' }, '<C-h>', '<C-w><C-h>')
set('i', '<C-j>', '<Esc><C-w><C-j>')
set('i', '<C-k>', '<Esc><C-w><C-k>')
set('i', '<C-l>', '<Esc><C-w><C-l>')
set('i', '<C-h>', '<Esc><C-w><C-h>')

-- Center screen when jumping
set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Better indenting in visual mode
set('v', '<', '<gv', { desc = 'Indent left and reselect' })
set('v', '>', '>gv', { desc = 'Indent right and reselect' })

set('n', '<leader>xl', '<cmd>.lua<CR>', { desc = 'Execute the current line' })
set('n', '<leader>xf', '<cmd>source %<CR>', { desc = 'Execute the current file' })

local function executeSelectedLua()
  local selected_text = vim.fn.getreg '"'
  local func, err = load(selected_text)
  if func then
    local success, result = pcall(func)
    if not success then
      print('Error executing Lua code: ' .. result)
    end
  else
    print('Error loading Lua code: ' .. err)
  end
end

set('v', '<leader>x', executeSelectedLua, { noremap = true, silent = true, desc = 'Execute the selected Lua code' })
set('n', '[d', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Go to previous [D]iagnostic message' })
set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end,
  { desc = 'Go to next [D]iagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
