return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000,
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'gruvbox-material',
      callback = function()
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#867462' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#D17A3A' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#867462' })
        vim.cmd [[
            hi  String cterm=NONE gui=NONE
            hi  Comment  cterm=NONE gui=NONE
          ]]
      end,
    })
    vim.g.gruvbox_material_foreground = 'material'
    vim.g.gruvbox_material_background = 'soft'
    vim.g.gruvbox_material_better_performance = 1
    vim.cmd.colorscheme 'gruvbox-material'
  end,
}
