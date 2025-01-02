local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local on_attach = function(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('Format', { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.formatting_seq_sync()
      end,
    })
  end
end

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
    biome = {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'html', 'javascript', 'typescript', 'react', 'vue', 'typescriptreact', 'typescript.tsx', 'javascriptreact' },
    },
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
