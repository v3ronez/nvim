return {
  'abreujp/scholar.nvim',
  priority = 1000,
  config = function()
    require('scholar').setup {
      contrast = 'soft',
      palette_overrides = {
        light0_soft = '#E8D5BE',
        light1 = '#EFDFCA',
        light3 = '#E0C9AF',
        light4 = '#CDB499',
        faded_purple = '#8A4A24',
        faded_orange = '#77402B',
        faded_red = '#7C4931',
        dark1 = '#39231F',
      },

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'scholar',
        callback = function()
          vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#3A2520' })
          vim.api.nvim_set_hl(0, 'LineNr', { fg = '#3A2520' })
          vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#3A2520' })
          vim.api.nvim_set_hl(0, 'LspReferenceText', { fg = '#553F35', bg = '#CDB69A' })
          vim.api.nvim_set_hl(0, 'LspReferenceRead', { fg = '#553F35', bg = '#CDB69A' })
          vim.api.nvim_set_hl(0, 'LspReferenceWrite', { fg = '#553F35', bg = '#CDB69A' })
        end,
      }),
    }
  end,
}
