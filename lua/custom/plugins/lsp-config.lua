return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    local servers = {
      intelephense = {
        filetypes = { 'php', 'blade', 'php_only' },
        default_config = {
          init_options = {
            licenceKey = '$HOME/intelephense/licence.txt',
          },
        },
        settings = {
          intelephense = {
            filetypes = { 'php', 'blade', 'php_only' },
            files = {
              associations = { '*.php', '*.blade.php' }, -- Associating .blade.php files as well
              maxSize = 5000000,
            },
          },
        },
      },
      gopls = {
        analyses = {
          -- unusedparams = true,
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        completeUnimported = true,
        staticcheck = true,
        gofumpt = true,
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules', '-.nvim' },
        semanticTokens = true,
        root_dir = require('lspconfig').util.root_pattern('go.work', 'go.mod', '.git'),

        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*.go',
          callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { 'source.organizeImports' } }
            local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
            for cid, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
                  vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
              end
            end
            vim.lsp.buf.format { async = false }
          end,
        }),
      },
      html = {
        capabilities = capabilities,
        filetypes = { 'html', 'templ', 'htmx' },
      },
      htmx = {
        capabilities = capabilities,
        filetypes = { 'html', 'templ' },
      },
      templ = {
        capabilities = capabilities,
        vim.filetype.add { extension = { templ = 'templ' } },
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = vim.lsp.buf.format }),
        -- vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = custom_format }),
      },
      cssls = {
        capabilities = capabilities,
        filetypes = { 'css' },
      },
      dockerls = {
        capabilities = capabilities,
        filetypes = { 'dockerfile' },
      },
      docker_compose_language_service = {
        capabilities = capabilities,
        filetypes = { 'yaml', 'docker-compose' },
      },
      tailwindcss = {
        capabilities = capabilities,
        filetypes = { 'templ', 'html', 'astro', 'javascript', 'typescript', 'react', 'blade' },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = 'html',
            },
          },
        },
      },
      -- markdownlint = {
      --   lint = {
      --     enabled = false,
      --   },
      -- },
      rust_analyzer = {
        capabilities = capabilities,
        filetypes = { 'rust' },
      },
      ts_ls = {},
      hls = {
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
        flags = {
          debounce_text_changes = 150, -- debounce for text changes (to avoid excessive requests)
        },
        settings = {
          haskell = {
            -- Optimization: Enable in-memory compilation instead of using disk storage
            -- useInMemoryCompilation = true,

            -- Optional: Disable some HLS features to reduce overhead for large projects
            -- formattingProvider = 'none', -- Disable formatting if you want to use another formatter
            hlintOn = true, -- Disable hlint for performance (can enable later if needed)
            lintOn = true, -- Disable linting (can be enabled later if needed)
            -- maxOnDemandDiagnostics = 10, -- Limit the number of diagnostics per file
            -- addPkgDeps = false, -- Disable automatic package dependency updates

            -- Optional: Limit the number of threads HLS uses for better performance on larger projects
            -- threads = 4,  -- Uncomment to set a specific number of threads (adjust according to your system)
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- require('lspconfig').hls.setup {
    -- }

    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code,
      'html',
      -- 'phpactor',
      'jsonls',
      'rust_analyzer',
      'templ',
      'htmx',
      'cmake',
      'gopls',
      'intelephense',
      'hls',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        -- This handles overriding only values explicitly passed
        function(server_name)
          local server = servers[server_name] or {}
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
