return {
  'fcoury/termy.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'termy-dark',
      callback = function()
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#5f6f99' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ffe28a' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#5f6f99' })
        vim.cmd [[
              hi  String cterm=NONE gui=NONE
              hi  Comment cterm=NONE gui=NONE
              hi  @comment cterm=NONE gui=NONE
        ]]
      end,
    })
  end,
}
