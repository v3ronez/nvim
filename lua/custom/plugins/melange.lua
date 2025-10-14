return {
  'savq/melange-nvim',
  -- 'Martin1887/melangeDarkerWarm-nvim',
  name = 'melange',
  priority = 1000,
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'melange',
      callback = function()
        local orange_color = '#BA5E34'
        local soft_dark = '#47403C'
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

        vim.api.nvim_set_hl(0, 'Comment', { fg = orange_color })

        vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = '#EBC06D', bg = soft_dark, bold = true })
      end,
    })
  end,
}
