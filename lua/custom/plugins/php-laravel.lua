-- root path to blade_nav search views
vim.g.blade_nav = {
  laravel_componets = {
    'resources/views',
  },
}
return {
  {
    -- Add neotest-pest plugin for running PHP tests.
    -- A package is also available for PHPUnit if needed.
    'nvim-neotest/neotest',
    dependencies = { 'olimorris/neotest-phpunit', 'nvim-neotest/nvim-nio' },
    opts = { adapters = { 'neotest-phpunit' } },
  },
  {
    -- Add the Laravel.nvim plugin which gives the ability to run Artisan commands
    -- from Neovim.
    'adalessa/laravel.nvim',
    dependencies = {
      'tpope/vim-dotenv',
      'nvim-telescope/telescope.nvim',
      'MunifTanjim/nui.nvim',
      'kevinhwang91/promise-async',
    },
    event = { 'VeryLazy' },
    cmd = { 'Sail', 'Artisan', 'Composer', 'Npm', 'Yarn', 'Laravel' },
    config = true,
    opts = {
      lsp_server = 'intelephense',
      features = { null_ls = { enable = true } },
      route_info = {
        enable = true,
        position = 'right',
        middlewares = true,
        method = true,
        uri = true,
      },
    },
  },
  {
    'ricardoramirezr/blade-nav.nvim',
    dependencies = { -- totally optional
      'hrsh7th/nvim-cmp', -- if using nvim-cmp
    },
    ft = { 'blade', 'php' }, -- optional, improves startup time
    opts = {
      close_tag_on_complete = false, -- default: true
    },
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
