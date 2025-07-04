return {
  'adibhanna/laravel.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  cmd = { 'Artisan', 'Composer', 'Laravel' },
  keys = {
    { '<leader>pla', ':Artisan<cr>', desc = 'Laravel Artisan' },
    { '<leader>plc', ':Composer<cr>', desc = 'Composer' },
    { '<leader>plr', ':LaravelRoute<cr>', desc = 'Laravel Routes' },
    { '<leader>plm', ':LaravelMake<cr>', desc = 'Laravel Make' },
  },
  ft = { 'php', 'blade' },
  event = { 'VeryLazy' },
  config = function()
    require('laravel').setup {
      notifications = false,
    }
  end,
}
