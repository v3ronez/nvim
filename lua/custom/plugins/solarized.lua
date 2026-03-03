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
    on_colors = function(colors, color)
      return {
        base3 = '#FFF3D0',
        base00 = '#5F737A',
        -- yellow = '#A77F07',a
        yellow = '#B37100',
        -- green = '#767A02',
        green = '#6B7A09',
      }
    end,
    on_highlights = function(colors, color)
      local groups = {
        -- local normal_color = '#FFF3D0'
        LineNr = { fg = '#D17A3A', bg = colors.base3 },
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
        TelescopeNormal = { bg = colors.base3 },
        Visual = { fg = 'NONE', bg = '#E1DBC8' },
      }

      vim.cmd [[
            hi  String cterm=NONE gui=NONE
            hi  Comment  cterm=NONE gui=NONE
            hi  Parameter cterm=NONE gui=NONE
      ]]
      return groups
    end,
  },
  config = function(_, opts)
    require('solarized').setup(opts)
  end,
}
