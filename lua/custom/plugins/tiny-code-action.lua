return {
  'rachartier/tiny-code-action.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'folke/snacks.nvim',
      opts = {
        terminal = {},
      },
    },
  },
  event = 'LspAttach',
  opts = {
    backend = 'difftastic',
    picker = {
      'snacks',
      opts = {
        layout = {
          preset = 'ivy',
          layout = {
            box = 'vertical',
            position = 'bottom',
            backdrop = false,
            border = 'rounded',
            title = ' {title} {live} {flags}',
            title_pos = 'left',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
            { win = 'preview', title = '{preview}', height = 0.5, border = 'top' },
          },
        },
      },
    },
  },
}
