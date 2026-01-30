return {
  'wincent/base16-nvim',
  lazy = false, -- load at start
  priority = 1000, -- load first
  config = function()
    -- Less visible window separator
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 1250067 })
    -- Make comments more prominent -- they are important.
    local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
    vim.api.nvim_set_hl(0, 'Comment', bools)

    vim.api.nvim_set_hl(0, 'LspReferenceText', { fg = 'None', bg = '#49433E' })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { fg = 'None', bg = '#49433E' })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { fg = 'None', bg = '#49433E' })
  end,
}
