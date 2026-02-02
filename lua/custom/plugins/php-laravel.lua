return {
  {
    -- Add neotest-pest plugin for running PHP tests.
    'nvim-neotest/neotest',
    dependencies = { 'olimorris/neotest-phpunit', 'nvim-neotest/nvim-nio' },
    opts = { adapters = { 'neotest-phpunit' } },
  },
  {
    -- Add a Treesitter parser for Laravel Blade to provide Blade syntax highlighting.
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'php_only',
        'php',
      })
      return opts
    end,
    config = function(_, opts)
      vim.filetype.add {
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      }

      -- Register Blade parser for nvim-treesitter v1.0+ (get_parser_configs removed)
      local parsers = require 'nvim-treesitter.parsers'
      parsers.blade = {
        install_info = {
          url = 'https://github.com/EmranMR/tree-sitter-blade',
          files = { 'src/parser.c' },
          branch = 'main',
        },
        filetype = 'blade',
      }

      require('nvim-treesitter').setup(opts)
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
