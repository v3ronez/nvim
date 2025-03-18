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
          --PSR12 plus v3ronez confort
          -- '--rules=@PSR12,phpdoc_indent,line_ending,array_indentation,blank_line_before_statement,method_chaining_indentation,type_declaration_spaces,types_spaces,no_useless_return,semicolon_after_instruction',
          '--rules=@PSR12,not_operator_with_successor_space,no_blank_lines_after_phpdoc,-group_import,declare_strict_types,fully_qualified_strict_types,single_import_per_statement,types_spaces,no_unused_imports,array_indentation,statement_indentation,method_chaining_indentation,array_syntax,binary_operator_spaces,blank_line_after_namespace,blank_line_after_opening_tag,class_attributes_separation,concat_space,declare_equal_normalize,-elseif,encoding,indentation_type,-no_useless_else,no_useless_return,ordered_imports,ternary_operator_spaces,no_extra_blank_lines,no_multiline_whitespace_around_double_arrow,multiline_whitespace_before_semicolons,no_singleline_whitespace_before_semicolons,no_spaces_around_offset,ternary_to_null_coalescing,whitespace_after_comma_in_array,trim_array_spaces,trailing_comma_in_multiline,unary_operator_spaces,blank_line_before_statement,no_whitespace_before_comma_in_array',
          '--allow-risky=yes',
          '$FILENAME',
        },
        stdin = false,
      },
      ['ml-format'] = {
        command = './_build/_private/default/.dev-tool/ocamlformat/ocamlformat/target/bin/ocamlformat',
        args = {
          '--enable-outside-detected-project',
          '--name',
          '$FILENAME',
          '-',
        },
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
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      ocaml = { 'ml-format' },
      ocaml_mlx = { 'ocamlformat_mlx' },
    },
  },
}
