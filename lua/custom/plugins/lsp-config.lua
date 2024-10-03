local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
return {
  'neovim/nvim-lspconfig',
  opts = {
    -- @type lspconfig.options
    servers = {
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
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
    biome = {},
    html = {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'html', 'templ', 'htmx' },
    },
    tailwindcss = {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'html', 'templ', 'javascript', 'typescript', 'react' },
      settings = {
        tailwindCSS = {
          includeLanguages = {
            templ = 'html',
          },
        },
      },
    },
  },
}
