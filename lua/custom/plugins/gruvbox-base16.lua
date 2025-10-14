return {
  'wincent/base16-nvim',
  lazy = false, -- load at start
  priority = 1000, -- load first
  config = function()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'gruvbox-dark-hard',
      callback = function()
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 1250067 })

        -- -- background-dependent
        -- vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#1C1916' })
        -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#1C1916' })
        -- vim.api.nvim_set_hl(0, 'VertSplit', { bg = '#1C1916' })
        -- vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#1C1916' })
        -- vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#1C1916' })
        --
        local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
        vim.api.nvim_set_hl(0, 'Comment', bools)

        local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
        vim.api.nvim_set_hl(
          0,
          'LspSignatureActiveParameter',
          { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true }
        )
        -- current relative number
        vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'grey' })
        vim.api.nvim_set_hl(0, 'LineNr', { fg = '#F5C056' })
        vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'grey' })
      end,
    })
    -- vim.cmd [[hi Normal ctermbg=NONE]]
    -- vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 1250067 })
    -- local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
    -- vim.api.nvim_set_hl(0, 'Comment', bools)
    -- local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
    -- vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
    --
    -- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'grey' })
    -- vim.api.nvim_set_hl(0, 'LineNr', { fg = '#EBC06D' })
    -- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'grey' })
  end,
}
