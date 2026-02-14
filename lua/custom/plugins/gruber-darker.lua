return {
  'blazkowolf/gruber-darker.nvim',
  priority = 1000,
  opts = {
    italic = {
      strings = false,
      comments = false,
      operators = false,
      folds = false,
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'gruber-darker',
      callback = function()
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'LineNr', { link = 'GruberDarkerYellowBold' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'javaScript', { link = 'NONE' })
      end,
    })
  end,
}
