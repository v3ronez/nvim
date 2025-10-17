return {
  'ellisonleao/gruvbox.nvim',
  lazy = false, -- load at start
  priority = 1000, -- load first
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'gruvbox',
      callback = function()
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 1250067 })
        --
        -- local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
        -- vim.api.nvim_set_hl(0, 'Comment', bools)

        vim.cmd 'hi Normal guibg=#111122'

        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#F5C056' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#383430' })
        vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#383430' })
        vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#383430' })
      end,
    })
  end,
}
