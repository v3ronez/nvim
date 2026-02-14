return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000000,
  opts = {
    transparent = true,
    borderless_pickers = false,
    -- saturation = 0.95,
    cache = true,
  },
  init = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'cyberdream',
      callback = function()
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#3c4048', bg = 'none' })
        vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = '#7b8496' })
        vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#232429' })
        vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#232429' })
        vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { bg = '#232429', underline = true })
        vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff' })
        -- current relative number
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#4f5359' })
        vim.api.nvim_set_hl(0, 'Comment', { fg = '#fa62a0' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#FFFFFF' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#4f5359' })
      end,
    })
  end,
}
