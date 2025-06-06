return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      disable_background = true,
      styles = {
        italic = false,
        base = '#000000', -- Define o fundo como preto
        overlay = '#000000',
        surface = '#000000',
      },
      highlight_groups = {
        --statusLine
        StatusLine = { fg = '#f1f1f1', bg = 'base', blend = 10 },
        StatusLineNC = { fg = 'subtle', bg = 'surface' },
        --statudLine end
        --telescope
        TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
        TelescopeNormal = { bg = 'none' },
        TelescopePromptNormal = { bg = 'base' },
        TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
        TelescopeSelection = { fg = 'text', bg = 'base' },
        TelescopeSelectionCaret = { fg = 'iris', bg = 'iris' },
        --telescope end
      },
    }

    -- vim.cmd 'colorscheme rose-pine-moon'
    -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'none' })
  end,
}
