return {
  'adibhanna/laravel.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  cmd = { 'Artisan', 'Composer', 'Laravel' },
  ft = { 'php', 'blade' },
  event = { 'VeryLazy' },
  config = function()
    require('laravel').setup {
      notifications = false,
    }
  end,
}
