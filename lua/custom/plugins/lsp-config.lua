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
    -- Autoformatting
    'stevearc/conform.nvim',

    -- Schema information
    'b0o/SchemaStore.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- vim.keymap.set('n', 'K', function()
        --   vim.lsp.buf.hover { border = 'rounded' }
        -- end, { buffer = 0 })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = 0, desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'gi', builtin.lsp_implementations, { buffer = 0, desc = '[G]oto [I]mplementation' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = 0, desc = '[G]oto [D]eclaration' })
        vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = 0, desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', '<space>ws', builtin.lsp_workspace_symbols, { buffer = 0, desc = '[W]orkspace [S]ymbols' })
        vim.keymap.set('n', '<space>ds', builtin.lsp_document_symbols, { buffer = 0, desc = '[D]ocument [S]ymbols' })
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = 0, desc = '[C]ode [A]ction' })
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = 0, desc = '[R]e[n]ame' })
        vim.keymap.set('n', '<space>li', function()
          vim.cmd 'LspInfo'
        end, { buffer = 0, desc = '[L]sp [I]nfo' })
        vim.keymap.set('n', '<space>lr', function()
          vim.cmd 'LspRestart'
        end, { buffer = 0, desc = '[L]sp [R]estart' })
        vim.keymap.set('n', '<space>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, { buffer = 0, desc = '[T]oggle Inlay [H]ints' })

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
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }
    local border = {
      { '╭', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╮', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '╯', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '╰', 'FloatBorder' },
      { '│', 'FloatBorder' },
    }

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
    -- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
    local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }
    local vtsls_config = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    }
    local vue_ls_config = {
      on_init = function(client)
        client.handlers['tsserver/request'] = function(_, result, context)
          local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
          if #clients == 0 then
            vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
            return
          end
          local ts_client = clients[1]

          local param = unpack(result)
          local id, command, payload = unpack(param)
          ts_client:exec_cmd({
            title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
            command = 'typescript.tsserverRequest',
            arguments = {
              command,
              payload,
            },
          }, { bufnr = context.bufnr }, function(_, r)
            local response_data = { { id, r.body } }
            ---@diagnostic disable-next-line: param-type-mismatch
            client:notify('tsserver/response', response_data)
          end)
        end
      end,
    }

    local templ_format = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local cmd = 'templ fmt ' .. vim.fn.shellescape(filename)

      vim.fn.jobstart(cmd, {
        on_exit = function()
          if vim.api.nvim_get_current_buf() == bufnr then
            vim.cmd 'e!'
          end
        end,
      })
    end
    -- nvim 0.11 or above
    vim.lsp.config('vtsls', vtsls_config)
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.enable { 'vtsls', 'vue_ls' }

    local extend = function(name, key, values)
      local mod = require(string.format('lspconfig.configs.%s', name))
      local default = mod.default_config
      local keys = vim.split(key, '.', { plain = true })
      while #keys > 0 do
        local item = table.remove(keys, 1)
        default = default[item]
      end

      if vim.islist(default) then
        for _, value in ipairs(default) do
          table.insert(values, value)
        end
      else
        for item, value in pairs(default) do
          if not vim.tbl_contains(values, item) then
            values[item] = value
          end
        end
      end
      return values
    end

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
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = '',
            },
            -- schemas = require("schemastore").yaml.schemas(),
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
      ocamllsp = {
        cmd = { 'ocamllsp' },
        settings = {
          codelens = { enable = true },
          inlayHints = { enable = false },
          syntaxDocumentation = { enable = true },
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
      templ = {
        capabilities = capabilities,
        vim.filetype.add { extension = { templ = 'templ' } },
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'templ',
          command = 'setlocal commentstring=<!--\\ %s\\ -->',
        }),
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = templ_format }),
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
        filetypes = extend('tailwindcss', 'filetypes', { 'templ', 'html', 'astro', 'javascript', 'typescript', 'react', 'blade', 'ocaml.mlx' }),
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                [[class: "([^"]*)]],
                [[className="([^"]*)]],
              },
            },
            includeLanguages = extend('tailwindcss', 'settings.tailwindCSS.includeLanguages', {
              ['templ'] = 'html',
              ['ocaml.mlx'] = 'html',
            }),
          },
        },
      },
      rust_analyzer = {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            check = {
              allTargets = false,
            },
            cargo = {
              targetDir = true,
            },
            files = {
              excludeDirs = { 'target', 'node_modules', '.git', '.sl' },
            },
          },
        },
        filetypes = { 'rust' },
      },
      ts_ls = {
        capabilities = capabilities,
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
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
      'cmake',
      'gopls',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = true,
      handlers = {
        function(server_name)
          local handlers = {
            ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
              border = border,
            }),
            ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
              border = border,
            }),
          }

          local server = servers[server_name] or {}
          server.handlers = handlers
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
