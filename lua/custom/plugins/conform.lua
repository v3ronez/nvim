return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[C]ode format',
    },
  },
  opts = {
    notify_on_error = false,
    ['php_cs_fixer'] = {
      command = 'php-cs-fixer',
      args = {
        'fix',
        '--no-cache',
        '--rules=@PSR12', -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
        'phpdoc_indent',
        'line_ending',
        'array_indentation',
        'blank_line_before_statement',
        'method_chaining_indentation',
        'type_declaration_spaces',
        'types_spaces',
        'no_useless_return',
        'semicolon_after_instruction',
        '$FILENAME',
      },
      stdin = false,
    },
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 800,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      php = { 'php_cs_fixer' },
      blade = { 'blade-formatter', 'rustywind' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
