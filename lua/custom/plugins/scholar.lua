return {
  'abreujp/scholar.nvim',
  priority = 1000,
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'scholar',
      callback = function()
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#3A2520' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#3A2520' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#3A2520' })
      end,
    })
  end,
}
