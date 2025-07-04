return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'L3MON4D3/LuaSnip',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        vim.keymap.set('n', '<C-h>', function()
          vim.lsp.buf.hover { border = 'rounded' }
        end, { buffer = 0 })
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('gT', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
    capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), capabilities, {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    })
    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    -- vim.diagnostic.config {
    --   severity_sort = true,
    --   float = { border = 'rounded', source = 'if_many' },
    --   underline = { severity = vim.diagnostic.severity.ERROR },
    --   signs = vim.g.have_nerd_font and {
    --     text = {
    --       [vim.diagnostic.severity.ERROR] = '󰅚 ',
    --       [vim.diagnostic.severity.WARN] = '󰀪 ',
    --       [vim.diagnostic.severity.INFO] = '󰋽 ',
    --       [vim.diagnostic.severity.HINT] = '󰌶 ',
    --     },
    --   } or {},
    --   virtual_text = {
    --     source = 'if_many',
    --     spacing = 2,
    --     format = function(diagnostic)
    --       local diagnostic_message = {
    --         [vim.diagnostic.severity.ERROR] = diagnostic.message,
    --         [vim.diagnostic.severity.WARN] = diagnostic.message,
    --         [vim.diagnostic.severity.INFO] = diagnostic.message,
    --         [vim.diagnostic.severity.HINT] = diagnostic.message,
    --       }
    --       return diagnostic_message[diagnostic.severity]
    --     end,
    --   },
    -- }
    --

    --Test
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = 'rounded',
        source = true,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
          [vim.diagnostic.severity.WARN] = 'WarningMsg',
        },
      },
    }

    local servers = {
      intelephense = {
        filetypes = { 'php', 'blade', 'php_only' },
        capabilities = capabilities,
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
            format = {
              braces = 'k&r',
            },
          },
        },
      },
      gopls = {
        analyses = {
          modernize = true,
          unusedparams = true,
          shadow = true,
          unusedwrite = true,
          unusedvariable = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        staticcheck = true,
        gofumpt = true,
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules', '-.nvim' },
        semanticTokens = true,
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
          pattern = '*.go',
          callback = function()
            local params = vim.lsp.util.make_range_params(0, 'utf-8')
            params.context = { only = { 'source.organizeImports' } }
            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
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
        root_dir = require('lspconfig').util.root_pattern('go.work', 'go.mod', '.git'),
      },
      html = {
        capabilities = capabilities,
        filetypes = { 'html', 'templ' },
      },
      -- htmx = {
      --   capabilities = capabilities,
      --   filetypes = { 'html', 'templ' },
      -- },
      templ = {
        capabilities = capabilities,
        vim.filetype.add { extension = { templ = 'templ' } },
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = vim.lsp.buf.format }),
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
        init_options = {
          userLanguages = {
            elixir = 'phoenix-heex',
            eruby = 'erb',
            heex = 'phoenix-heex',
          },
        },
        filetypes = 'filetypes',
        { 'templ', 'html', 'astro', 'javascript', 'typescript', 'react', 'blade' },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                [[class: "([^"]*)]],
                [[className="([^"]*)]],
              },
            },
            includeLanguages = {
              ['templ'] = 'html',
            },
          },
        },
      },
      rust_analyzer = {
        cmd = { 'rust-analyzer' },
        root_markers = { 'Cargo.lock' },
        filetypes = { 'rust' },
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
            diagnostics = {
              enable = true,
            },
          },
        },
      },
      ts_ls = {
        capabilities = capabilities,
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
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
      -- lexical = {
      --   cmd = { '$HOME/.local/share/nvim/mason/bin/lexical', 'server' },
      --   root_dir = require('lspconfig.util').root_pattern { 'mix.exs' },
      --   filetypes = { 'elixir', 'eelixir', 'heex' },
      --   server_capabilities = {
      --     completionProvider = vim.NIL,
      --     definitionProvider = true,
      --   },
      -- },
    }
    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code,
      'html',
      'jsonls',
      'rust_analyzer',
      'intelephense',
      'ts_ls',
      'templ',
      -- 'htmx',
      'cmake',
      'gopls',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = true,
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
