return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000000,
  opts = {
    transparent = true,
    borderless_pickers = false,
    saturation = 0.95,
    cache = true,
    highlights = {
      WinSeparator = { bg = '#3c4048', fg = 'none' },
      IndentBlanklineChar = { fg = '#7b8496' },
      TreesitterContext = { bg = '#232429' },
      TreesitterContextLineNumber = { bg = '#232429' },
      TreesitterContextBottom = { bg = '#232429', underline = true },
      LineNrAbove = { fg = '#4f5359' },
      LineNr = { fg = '#FFFFFF' },
      LineNrBelow = { fg = '#4f5359' },
    },
  },
}
