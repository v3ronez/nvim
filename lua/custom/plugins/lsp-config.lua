return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'rachartier/tiny-inline-diagnostic.nvim',
      event = 'VeryLazy', -- Or `LspAttach`
      priority = 1000, -- needs to be loaded in first
      config = function()
        require('tiny-inline-diagnostic').setup()
        vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
      end,
    },
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })

          if client and client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.refresh()
          end
          -- codelens above function
          --   if client and client.server_capabilities.codeLensProvider then
          --     local ns = vim.api.nvim_create_namespace('codelens-' .. event.buf)
          --     local refresh_and_display = function()
          --       vim.api.nvim_buf_clear_namespace(event.buf, -1, 0, -1)
          --       local lenses = vim.lsp.codelens.get(event.buf)
          --       if not lenses then
          --         return
          --       end
          --
          --       vim.api.nvim_buf_clear_namespace(event.buf, ns, 0, -1)
          --
          --       for _, lens in ipairs(lenses) do
          --         if lens.command and lens.command.title then
          --           local line = lens.range.start.line
          --           local text = lens.command.title
          --           vim.api.nvim_buf_set_extmark(event.buf, ns, line, 0, {
          --             virt_lines = { { { text, 'Comment' } } },
          --             virt_lines_above = true,
          --           })
          --         end
          --       end
          --     end
          --
          --     vim.api.nvim_create_autocmd({ 'LspAttach', 'BufEnter', 'CursorHold', 'InsertLeavePre' }, {
          --       buffer = event.buf,
          --       callback = function()
          --         vim.lsp.codelens.refresh()
          --         refresh_and_display()
          --       end,
          --     })
          --     vim.lsp.codelens.refresh()
          --     refresh_and_display()
          --   end
          -- end
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

        -- --codelens setup with virtual text
        -- --
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })
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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    local servers = {
      ocamllsp = {
        cmd = { 'ocamllsp' },
        filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason', 'dune' },
        root_dir = require('lspconfig').util.root_pattern('*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace'),
        settings = {
          codelens = { enable = true },
          -- inlayHints = { enable = true },
          syntaxDocumentation = { enable = true },
        },
        server_capabilities = { semanticTokensProvider = false },
      },
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
        filetypes = extend('tailwindcss', 'filetypes', { 'ocaml.mlx', 'templ', 'html', 'astro', 'javascript', 'typescript', 'react', 'blade' }),
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                [[class: "([^"]*)]],
                [[className="([^"]*)]],
              },
            },
            includeLanguages = extend('tailwindcss', 'settings.tailwindCSS.includeLanguages', {
              ['ocaml.mlx'] = 'html',
              ['templ'] = 'html',
            }),
          },
        },
      },
      rust_analyzer = {
        capabilities = capabilities,
        filetypes = { 'rust' },
      },
      ts_ls = {},
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
      'templ',
      'htmx',
      'cmake',
      'gopls',
      'intelephense',
      'ocamllsp',
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
