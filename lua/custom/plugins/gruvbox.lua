return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  config = true,
  opts = {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = false,
    bold = true,
    italic = {
      strings = false,
      emphasis = false,
      comments = false,
      operators = false,
      folds = false,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = 'soft', -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {
      LineNrAbove = { fg = '#DC8F58' },
      LineNr = { fg = '#D17A3A' },
      LineNrBelow = { fg = '#DC8F58' },
    },
    dim_inactive = false,
    transparent_mode = false,
  },
}
