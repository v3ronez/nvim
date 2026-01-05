return {
  'andweeb/presence.nvim',
  config = function()
    require('presence').setup {
      main_image = 'file',

      workspace_text = '',
      editing_text = '',
    }
  end,
}
