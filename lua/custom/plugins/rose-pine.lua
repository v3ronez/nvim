return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      variant = 'auto',
      dark_variant = 'moon',
      disable_background = false,
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
        -- --telescope
        TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
        TelescopeNormal = { bg = 'none' },
        TelescopePromptNormal = { bg = 'base' },
        TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
        TelescopeSelection = { fg = 'text', bg = 'base' },
        TelescopeSelectionCaret = { fg = 'iris', bg = 'iris' },
        --
        LineNrAbove = { fg = 'muted' },
        LineNr = { fg = 'gold' },
        LineNrBelow = { fg = 'muted' },
        ColorColumn = { bg = 'muted' },
      },
    }
  end,
}
