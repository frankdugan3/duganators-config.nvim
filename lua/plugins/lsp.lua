return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
    'stevearc/conform.nvim',
    'b0o/SchemaStore.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled)
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('ziggy', {}),
      pattern = 'ziggy',
      callback = function()
        vim.lsp.start {
          name = 'Ziggy LSP',
          cmd = { 'ziggy', 'lsp' },
          root_dir = vim.loop.cwd(),
          flags = { exit_timeout = 1000, debounce_text_changes = 200 },
        }
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('ziggy_schema', {}),
      pattern = 'ziggy_schema',
      callback = function()
        vim.lsp.start {
          name = 'Ziggy LSP',
          cmd = { 'ziggy', 'lsp', '--schema' },
          root_dir = vim.loop.cwd(),
          flags = { exit_timeout = 1000, debounce_text_changes = 200 },
        }
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('superhtml', {}),
      pattern = 'superhtml',
      callback = function()
        vim.lsp.start {
          name = 'SuperHTML LSP',
          cmd = { 'superhtml', 'lsp' },
          root_dir = vim.loop.cwd(),
          flags = { exit_timeout = 1000, debounce_text_changes = 200 },
        }
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      arduino_language_server = {},
      cssls = {
        init_options = { provideFormatter = false },
        settings = {
          -- Probably using Tailwind, will give false positives
          css = { validate = false },
        },
      },
      delve = {},
      elixirls = {
        root_dir = require('lspconfig.util').root_pattern { 'mix.exs' },
        server_capabilities = {
          completionProvider = true,
          definitionProvider = true,
          documentFormattingProvider = true,
        },
      },
      eslint = {},
      emmet_language_server = {
        filetypes = { 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'pug', 'typescriptreact', 'heex', 'elixir' },
      },
      gofumpt = {},
      goimports = {},
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      },
      markdownlint = {},
      marksman = {},
      prettier = {},
      shfmt = {},
      stylua = {},
      shellcheck = {},
      ts_ls = {},
      tailwindcss = {
        init_options = {
          userLanguages = {
            elixir = 'html-eex',
            eelixir = 'html-eex',
            heex = 'html-eex',
          },
        },
      },
      taplo = {},
      tinymist = {
        settings = {
          exportPdf = 'onType',
          formatterMode = 'typstyle',
        },
      },
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = 'tectonic',
              args = { '-X', 'compile', '%f', '--synctex', '--keep-logs', '--keep-intermediates' },
              onSave = true,
              forwardSearchAfter = true,
            },
            forwardSearch = {
              executable = 'zathura',
              args = { '--synctex-forward', '%1:1:%f', '%p' },
            },
          },
        },
      },
      zls = {},
      rust_analyzer = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
