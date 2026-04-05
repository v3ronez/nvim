return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback', quiet = true }
      end,
      mode = '',
      desc = '[C]ode format',
    },
  },
  opts = {
    notify_on_error = false,
    formatters = {
      ['php_cs_fixer'] = {
        command = 'php-cs-fixer',
        args = {
          'fix',
          '--using-cache=no',
          '--rules=@PSR12,no_unused_imports,no_blank_lines_after_phpdoc,no_unused_imports,blank_line_before_statement,blank_line_before_statement,blank_line_before_statement',
          -- '--rules=@PSR12,not_operator_with_successor_space,no_blank_lines_after_phpdoc,-group_import,declare_strict_types,fully_qualified_strict_types,single_import_per_statement,types_spaces,no_unused_imports,array_indentation,statement_indentation,method_chaining_indentation,array_syntax,binary_operator_spaces,blank_line_after_namespace,blank_line_after_opening_tag,class_attributes_separation,concat_space,declare_equal_normalize,-elseif,encoding,indentation_type,-no_useless_else,no_useless_return,ordered_imports,ternary_operator_spaces,no_extra_blank_lines,no_multiline_whitespace_around_double_arrow,multiline_whitespace_before_semicolons,no_singleline_whitespace_before_semicolons,no_spaces_around_offset,ternary_to_null_coalescing,whitespace_after_comma_in_array,trim_array_spaces,trailing_comma_in_multiline,unary_operator_spaces,blank_line_before_statement,no_whitespace_before_comma_in_array',
          '--allow-risky=yes',
          '$FILENAME',
        },
        stdin = false,
      },
      ['ml-format'] = {
        command = 'ocamlformat',
        args = {
          '--enable-outside-detected-project',
          '--name',
          '$FILENAME',
          '-',
        },
      },
      oxfmt = {
        condition = function(_, ctx)
          return vim.fs.find({ '.oxfmtrc.json', '.oxfmtrc.jsonc' }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      },
      prettierd = {
        condition = function(_, ctx)
          return vim.fs.find({
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.js',
            '.prettierrc.cjs',
            '.prettierrc.mjs',
            'prettier.config.js',
            'prettier.config.cjs',
            'prettier.config.mjs',
          }, {
            path = ctx.filename,
            upward = true,
            stop = vim.uv.os_homedir(),
          })[1] ~= nil
        end,
      },
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
      astro = { 'oxfmt', 'biome', 'prettierd', stop_after_first = true },
      javascript = { 'oxfmt', 'biome', 'prettierd', stop_after_first = true },
      typescript = { 'oxfmt', 'biome', 'prettierd', stop_after_first = true },
      javascriptreact = { 'oxfmt', 'biome', 'prettierd', stop_after_first = true },
      typescriptreact = { 'oxfmt', 'biome', 'prettierd', stop_after_first = true },
      svelte = { 'oxfmt', 'prettierd', stop_after_first = true },
      ocaml = { 'ocamlformat' },
      ocaml_mlx = { 'ocamlformat_mlx' },
      elixir = { 'mix' },
      eelixir = { 'mix' },
      heex = { 'mix' },
      surface = { 'mix' },
      vue = { 'oxfmt', 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
