return {
  'SergioBonatto/One-Half-Matte',
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'atomonelight_matte',
      callback = function()
        -- vim.api.nvim_set_hl(0, 'Function', { fg = '#5B8FA8' })
      end,
    })
  end,
}
