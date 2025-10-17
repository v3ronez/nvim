return {
  'savq/melange-nvim',
  -- 'Martin1887/melangeDarkerWarm-nvim',
  name = 'melange',
  priority = 1000,
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'melange',
      callback = function()
        -- local orange_color = '#CB7A54'
        local red_soft = '#bd8183'
        local soft_dark = '#47403C'
        -- local dark = '#1C1916'
        local dark = '#211C18'
        local yellow = '#EBC06D'
        -- background
        vim.api.nvim_set_hl(0, 'Normal', { bg = dark })

        -- background-dependent
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = dark })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = dark })
        vim.api.nvim_set_hl(0, 'VertSplit', { bg = dark })
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = dark })
        vim.api.nvim_set_hl(0, 'TabLineFill', { bg = dark })

        -- current relative number
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = yellow })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'grey' })

        vim.api.nvim_set_hl(0, 'Comment', { fg = red_soft, italic = false })
        vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = yellow, bg = soft_dark, bold = true })
        --Lsp References
        vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#443F3B' })
      end,
    })
  end,
}
