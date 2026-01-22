return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {
    style = {
      comments = { italic = false, bold = false },
      functions = { italic = false },
      variables = { italic = false },
    },
    variant = 'summer', -- "spring" | "summer" | "autumn" | "winter" (default)
    on_highlights = function(colors, color)
      local groups = {
        Comment = { fg = '#4FC3F7' },
        LineNr = { fg = '#D17A3A', bg = '#FDF6E3' },
        LineNrAbove = { fg = '#D17A3A', bg = colors.base3 },
        LineNrBelow = { fg = '#D17A3A', bg = colors.base3 },
        CursorLineNr = { fg = '#FDF6E3', bg = colors.base3 },
        CursorLine = { bg = colors.base3 },
        SignColumn = { bg = colors.base3 },
        DiagnosticSignInfo = { bg = 'NONE' },
        DiagnosticSignWarn = { bg = 'NONE' },
        DiagnosticSignError = { bg = 'NONE' },
        DiagnosticSignHint = { bg = 'NONE' },
        GitGutterAdd = { bg = 'NONE' },
        GitGutterChange = { bg = 'NONE' },
        GitGutterDelete = { bg = 'NONE' },
        GitSignsAdd = { bg = 'NONE' },
        GitSignsChange = { bg = 'NONE' },
        GitSignsDelete = { bg = 'NONE' },

        LspReferenceText = { fg = colors.base00, bg = '#E1DBC8' },
        LspReferenceWrite = { fg = colors.base00, bg = '#E1DBC8' },
        LspReferenceRead = { fg = colors.base00, bg = '#E1DBC8' },
        Visual = { fg = 'NONE', bg = '#E1DBC8' },
      }
      return groups
    end,
  },
  config = function(_, opts)
    require('solarized').setup(opts)
  end,
}
