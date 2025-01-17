return {
  'ccaglak/phptools.nvim',
  dependencies = {
    'ccaglak/namespace.nvim', -- optional - php namespace resolver
    -- "ccaglak/larago.nvim", -- optional -- laravel goto blade/components
    -- "ccaglak/snippets.nvim", -- optional -- native snippet expander
  },
  config = function()
    require('phptools').setup {
      ui = {
        enable = true, -- default:true; false only if you have a UI enhancement plugin
        fzf = false, -- default:false; tests requires fzf used only in tests module otherwise there might long list  of tests
      },
      custom_toggles = { -- delete if you dont use it
        enable = true, -- default:false
        { 'public', 'private' }, -- Add more custom toggle groups here
      },
    }

    local map = vim.keymap.set

    local ide_helper = require 'phptools.ide_helper' -- delete if you dont use it
    -- Laravel IDE Helper keymaps
    -- map('n', '<leader>lha', ide_helper.generate_all, { desc = 'Generate all IDE helpers' })
    -- map('n', '<leader>lhm', ide_helper.generate_models, { desc = 'Generate model helpers' })
    -- map('n', '<leader>lhf', ide_helper.generate_facades, { desc = 'Generate facade helpers' })
    -- map('n', '<leader>lht', ide_helper.generate_meta, { desc = 'Generate meta helper' })
    -- map('n', '<leader>lhi', ide_helper.install, { desc = 'Install IDE Helper package' })

    --PhpStuffs
    map('n', '<Leader>pm', '<cmd>PhpTools Method<cr>', { desc = '[P]HP [M]ethod' })
    map('n', '<Leader>pc', '<cmd>PhpTools Class<cr>', { desc = '[P]HP [C]lass' })
    map('n', '<Leader>pf', '<cmd>PhpTools Create<cr>', { desc = '[P]HP [F]actory entity' })
    map('n', '<Leader>pn', '<cmd>PhpTools Namespace<cr>', { desc = '[P]HP [N]amespace resolve' })
    map('v', '<Leader>pr', '<cmd>PhpTools Refactor<cr>', { desc = '[P]HP [R]efactor' })

    --#endregion
    local tests = require 'phptools.tests' -- delete if you have a test plugin
    map('n', '<Leader>ta', tests.test.all, { desc = 'Run all tests' })
    map('n', '<Leader>tf', tests.test.file, { desc = 'Run current file tests' })
    map('n', '<Leader>tl', tests.test.line, { desc = 'Run test at cursor' })
    map('n', '<Leader>ts', tests.test.filter, { desc = 'Search and run test' })
    map('n', '<Leader>tp', tests.test.parallel, { desc = 'Run tests in parallel' })
    map('n', '<Leader>tr', tests.test.rerun, { desc = 'Rerun last test' })
    map('n', '<Leader>ti', tests.test.selected, { desc = 'Run selected test file' })
  end,
}
