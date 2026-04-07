return {
  {
    -- Add neotest-pest plugin for running PHP tests.
    'nvim-neotest/neotest',
    dependencies = { 'olimorris/neotest-phpunit', 'nvim-neotest/nvim-nio' },
    opts = { adapters = { 'neotest-phpunit' } },
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
