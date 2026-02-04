return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'stevearc/conform.nvim',
    'b0o/SchemaStore.nvim',
  },
  config = function()
    -- LspAttach autocommand for keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Keymaps
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gd', '<C-]>', '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gr', require('snacks').picker.lsp_references, '[G]oto [R]eferences')
        map('gi', require('snacks').picker.lsp_implementations, '[G]oto [I]mplementation')
        map('gt', require('snacks').picker.lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('snacks').picker.lsp_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('snacks').picker.lsp_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<space>li', '<cmd>LspInfo<cr>', '[L]sp [I]nfo')
        map('<space>lr', '<cmd>LspRestart<cr>', '[L]sp [R]estart')
        map('<space>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')

        -- Document highlight
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        --
        -- --code Lens
        -- if client and client.server_capabilities.codeLensProvider then
        --   local codelens_augroup = vim.api.nvim_create_augroup('lsp-codelens-' .. event.buf, { clear = true })
        --   vim.lsp.codelens.refresh { bufnr = event.buf }
        --   vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        --     buffer = event.buf,
        --     group = codelens_augroup,
        --     callback = vim.lsp.codelens.refresh,
        --   })
        --
        --   vim.api.nvim_create_autocmd('LspDetach', {
        --     buffer = event.buf,
        --     callback = function()
        --       vim.api.nvim_clear_autocmds { group = codelens_augroup }
        --     end,
        --   })
        -- end

        if client then
          local supports_highlight = false

          -- Check if client supports document highlight (Neovim 0.10 and 0.11 compatible)
          if vim.fn.has 'nvim-0.11' == 1 then
            supports_highlight = client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
          else
            supports_highlight = client.supports_method and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
          end

          if supports_highlight then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
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
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
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

    -- local border = {
    --   { '╭', 'FloatBorder' },
    --   { '─', 'FloatBorder' },
    --   { '╮', 'FloatBorder' },
    --   { '│', 'FloatBorder' },
    --   { '╯', 'FloatBorder' },
    --   { '─', 'FloatBorder' },
    --   { '╰', 'FloatBorder' },
    --   { '│', 'FloatBorder' },
    -- }
    --
    -- local handlers = {
    --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    --     border = border,
    --   }),
    --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    --     border = border,
    --   }),
    -- }

    -- Apply borders to all LSP floating windows
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- Setup capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

    -- Helper function to extend filetypes/settings
    local extend = function(server_name, key, values)
      local ok, mod = pcall(require, string.format('lspconfig.configs.%s', server_name))
      if not ok then
        return values
      end

      local default = mod.default_config
      local keys = vim.split(key, '.', { plain = true })
      for _, item in ipairs(keys) do
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

    -- Templ formatter
    local function templ_format()
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

    local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_language_server_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
      enableForWorkspaceTypeScriptVersions = true,
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

    local handlers = {
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
      }),
      ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border,
      }),
    }

    vim.lsp.config('*', {
      capabilities = capabilities,
      handlers = handlers,
    })
    -- Server configurations using Neovim 0.11 API
    vim.lsp.config('intelephense', {
      cmd = { 'intelephense', '--stdio' },
      filetypes = { 'php', 'blade', 'php_only' },
      root_markers = { 'composer.json', '.git' },
      capabilities = capabilities,
      default_config = {
        init_options = {
          licenceKey = '$HOME/intelephense/licence.txt',
        },
      },
      settings = {
        intelephense = {
          files = {
            associations = { '*.php', '*.blade.php' },
            maxSize = 5000000,
          },
        },
      },
    })

    vim.lsp.config('gopls', {
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_markers = { 'go.work', 'go.mod', '.git' },
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })

    vim.lsp.config('html', {
      cmd = { 'vscode-html-language-server', '--stdio' },
      filetypes = { 'html', 'templ' },
      capabilities = capabilities,
    })

    vim.lsp.config('templ', {
      cmd = { 'templ', 'lsp' },
      filetypes = { 'templ' },
      root_markers = { 'go.mod', '.git' },
      capabilities = capabilities,
    })

    vim.lsp.config('cssls', {
      cmd = { 'vscode-css-language-server', '--stdio' },
      filetypes = { 'css', 'scss', 'less' },
      capabilities = capabilities,
    })

    vim.lsp.config('tailwindcss', {
      cmd = { 'tailwindcss-language-server', '--stdio' },
      filetypes = extend('tailwindcss', 'filetypes', { 'templ', 'html', 'astro', 'javascript', 'typescript', 'react', 'blade', 'vue' }),
      capabilities = capabilities,
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              [[class: "([^"]*)"]],
              [[className="([^"]*)"]],
            },
          },
          includeLanguages = extend('tailwindcss', 'settings.tailwindCSS.includeLanguages', {
            ['templ'] = 'html',
          }),
        },
      },
    })

    vim.lsp.config('rust_analyzer', {
      cmd = { 'rust-analyzer' },
      filetypes = { 'rust' },
      root_markers = { 'Cargo.toml', '.git' },
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            targetDir = true,
          },
        },
      },
    })

    vim.lsp.config('sqls', {
      cmd = { 'sqls' },
      filetypes = { 'sql' },
      capabilities = capabilities,
    })

    vim.lsp.config('ts_ls', {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
      },
      root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
      init_options = {
        plugins = { vue_plugin },
      },
      settings = {
        typescript = {
          tsserver = {
            useSyntaxServer = false,
          },
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    })

    vim.lsp.config('jsonls', {
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config('yamlls', {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml', 'yaml.docker-compose' },
      capabilities = capabilities,
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = '',
          },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    })

    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          diagnostics = {
            disable = { 'missing-fields' },
            globals = { 'vim' },
          },
        },
      },
    })

    vim.lsp.enable 'intelephense'
    vim.lsp.enable 'gopls'
    vim.lsp.enable 'html'
    vim.lsp.enable 'templ'
    vim.lsp.enable 'cssls'
    vim.lsp.enable 'tailwindcss'
    vim.lsp.enable 'rust_analyzer'
    vim.lsp.enable 'ts_ls'
    vim.lsp.enable 'jsonls'
    vim.lsp.enable 'yamlls'
    vim.lsp.enable 'lua_ls'
    vim.lsp.enable 'sqls'

    -- Templ filetype setup
    vim.filetype.add { extension = { templ = 'templ' } }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'templ',
      command = 'setlocal commentstring=<!--\\ %s\\ -->',
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.templ',
      callback = templ_format,
    })

    -- Go organize imports on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        local params = vim.lsp.util.make_range_params(0, 'utf-8')
        params.context = { only = { 'source.organizeImports' } }
        local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
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
    })

    -- Mason setup for automatic installation
    require('mason').setup()

    local ensure_installed = {
      'stylua',
      'html-lsp',
      'json-lsp',
      'rust-analyzer',
      'intelephense',
      'typescript-language-server',
      'templ',
      'gopls',
      'sqls',
      'tailwindcss-language-server',
      'css-lsp',
      'yaml-language-server',
      'lua-language-server',
      'vtsls',
      'vue-language-server',
    }

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }
  end,
}
