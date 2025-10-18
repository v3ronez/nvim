return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  config = function()
    require('gruvbox').setup {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = false,
        comments = true,
        operators = false,
        folds = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = 'hard', -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        -- Background = { bg = '#1f2022' },
        Background = { bg = '#1c1916' },
        LspReferenceText = { fg = 'None', bg = '#49433E' },
        LspReferenceWrite = { fg = 'None', bg = '#49433E' },
        LspReferenceRead = { fg = 'None', bg = '#49433E' },
        Operator = { fg = '#cf5c48' },
      },
      dim_inactive = false,
      transparent_mode = true,
    }
  end,
}
