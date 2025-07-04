local map = vim.keymap.set
return {
  {
    -- Add neotest-pest plugin for running PHP tests.
    -- A package is also available for PHPUnit if needed.
    'nvim-neotest/neotest',
    dependencies = { 'olimorris/neotest-phpunit', 'nvim-neotest/nvim-nio' },
    opts = { adapters = { 'neotest-phpunit' } },
  },
  {
    -- Add a Treesitter parser for Laravel Blade to provide Blade syntax highlighting.
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'blade',
        'php_only',
        'php',
      })
    end,
    config = function(_, opts)
      vim.filetype.add {
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      }

      require('nvim-treesitter.configs').setup(opts)
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = 'https://github.com/EmranMR/tree-sitter-blade',
          files = { 'src/parser.c' },
          branch = 'main',
        },
        filetype = 'blade',
      }
    end,
  },
  {
    -- Remove phpcs linter.
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        php = {},
      },
    },
  },
}
