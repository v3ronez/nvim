local map = vim.keymap.set

map('n', '<Leader>pl', '<cmd>:Laravel <cr>', { desc = '[P]HP [L]aravel commands' })
return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/nvim-nio',
      'ravitemer/mcphub.nvim', -- optional
    },
    cmd = { 'Laravel' },
    keys = {
      {
        '<leader>pll',
        function()
          Laravel.pickers.laravel()
        end,
        desc = 'Laravel: Open Laravel Picker',
      },
      {
        '<c-g>',
        function()
          Laravel.commands.run 'view:finder'
        end,
        desc = 'Laravel: Open View Finder',
      },
      {
        '<leader>pla',
        function()
          Laravel.pickers.artisan()
        end,
        desc = 'Laravel: Open Artisan Picker',
      },
      {
        '<leader>plt',
        function()
          Laravel.commands.run 'actions'
        end,
        desc = 'Laravel: Open Actions Picker',
      },
      {
        '<leader>plr',
        function()
          Laravel.pickers.routes()
        end,
        desc = 'Laravel: Open Routes Picker',
      },
      {
        '<leader>ple',
        function()
          Laravel.commands.run 'env:configure'
        end,
        desc = 'Laravel: Configure Environment',
      },
      {
        '<leader>plh',
        function()
          Laravel.run 'artisan docs'
        end,
        desc = 'Laravel: Open Documentation',
      },
      {
        '<leader>plm',
        function()
          Laravel.pickers.make()
        end,
        desc = 'Laravel: Open Make Picker',
      },
      {
        '<leader>plc',
        function()
          Laravel.pickers.commands()
        end,
        desc = 'Laravel: Open Commands Picker',
      },
      {
        '<leader>plo',
        function()
          Laravel.pickers.resources()
        end,
        desc = 'Laravel: Open Resources Picker',
      },
      {
        '<leader>plp',
        function()
          Laravel.commands.run 'command_center'
        end,
        desc = 'Laravel: Open Command Center',
      },
      {
        'gf',
        function()
          local ok, res = pcall(function()
            if Laravel.app('gf').cursorOnResource() then
              return "<cmd>lua Laravel.commands.run('gf')<cr>"
            end
          end)
          if not ok or not res then
            return 'gf'
          end
          return res
        end,
        expr = true,
        noremap = true,
      },
    },
    event = { 'VeryLazy' },
    opts = {
      features = {
        pickers = {
          provider = 'snacks', -- "snacks | telescope | fzf-lua | ui-select"
        },
      },
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
