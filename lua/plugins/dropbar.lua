return {
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      vim.ui.select = require('dropbar.utils.menu').select
    end,
  },
}
