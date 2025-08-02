return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters = {
      superhtml = {
        inherit = false,
        command = 'superhtml',
        stdin = true,
        args = { 'fmt', '--stdin-super' },
      },
      ziggy = {
        inherit = false,
        command = 'ziggy',
        stdin = true,
        args = { 'fmt', '--stdin' },
      },
      ziggy_schema = {
        inherit = false,
        command = 'ziggy',
        stdin = true,
        args = { 'fmt', '--stdin-schema' },
      },
    },
    formatters_by_ft = {
      sh = { 'shfmt' },
      templ = { 'templ' },
      go = { 'goimports', 'gofmt' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      typst = { 'tinymist' },
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier' },
      markdown = { 'prettierd', 'prettier' },
      html = { 'prettierd', 'prettier' },
      css = { 'prettierd', 'prettier' },
      shtml = { 'superhtml' },
      ziggy = { 'ziggy' },
      ziggy_schema = { 'ziggy_schema' },
    },
  },
}
