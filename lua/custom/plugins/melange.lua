return {
  'savq/melange-nvim',
  -- 'Martin1887/melangeDarkerWarm-nvim',
  name = 'melange',
  priority = 1000,
  config = function()
    local group = vim.api.nvim_create_augroup('OverrideMelange', {})
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'melange',
      callback = function()
        -- background
        vim.api.nvim_set_hl(0, 'Normal', { bg = '#1C1916' })

        -- background-dependent
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#1C1916' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#1C1916' })
        vim.api.nvim_set_hl(0, 'VertSplit', { bg = '#1C1916' })
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#1C1916' })
        vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#1C1916' })

        -- current relative number
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#EBC06D' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'grey' })
      end,
      group = group,
    })
  end,
}
