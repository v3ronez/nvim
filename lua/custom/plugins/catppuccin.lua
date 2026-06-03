return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        -- flavour = 'mocha', -- darker
        -- flavour = 'macchiato',
        flavour = 'latte',
        -- float = {
        -- 	-- transparent = true,
        -- 	-- solid = false,
        -- },
        no_italic = true,
        integrations = {
          diffview = true,
          fidget = true,
          harpoon = true,
          mason = true,
          native_lsp = { enabled = true },
          symbols_outline = true,
          snacks = {
            enabled = true,
            indent_scope_color = 'mauve',
          },
          render_markdown = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          neotest = true,
          blink_cmp = {
            style = 'bordered',
          },
        },
        highlight_overrides = {
          all = function(colors)
            local orange = '#DC8F58'
            return {
              LineNrAbove = { fg = colors.surface1 },
              LineNr = { fg = orange },
              LineNrBelow = { fg = colors.surface1 },

              String = { italic = false },
              Comment = { italic = false },
              ['@comment'] = { italic = false },
              Conditional = { italic = false },

              DiagnosticError = { italic = false },
              DiagnosticWarn = { italic = false },
              DiagnosticInfo = { italic = false },
              DiagnosticHint = { italic = false },
              DiagnosticOk = { italic = false },

              DiagnosticUnderlineError = { italic = false },
              DiagnosticUnderlineWarn = { italic = false },
              DiagnosticUnderlineInfo = { italic = false },
              DiagnosticUnderlineHint = { italic = false },

              DiagnosticVirtualTextError = { italic = false },
              DiagnosticVirtualTextWarn = { italic = false },
              DiagnosticVirtualTextInfo = { italic = false },
              DiagnosticVirtualTextHint = { italic = false },

              DiagnosticSignError = { italic = false },
              DiagnosticSignWarn = { italic = false },
              DiagnosticSignInfo = { italic = false },
              DiagnosticSignHint = { italic = false },
            }
          end,
        },
      }
    end,
  },
}
