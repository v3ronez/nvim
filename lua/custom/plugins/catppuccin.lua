return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'frappe',
        -- float = {
        -- 	-- transparent = true,
        -- 	-- solid = false,
        -- },
        integrations = {
          diffview = true,
          fidget = true,
          harpoon = true,
          mason = true,
          native_lsp = { enabled = true },
          noice = true,
          notify = true,
          symbols_outline = true,
          snacks = {
            enabled = true,
            indent_scope_color = 'mauve',
          },
          render_markdown = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          ufo = true,
          which_key = true,
        },
        highlight_overrides = {
          all = function(colors)
            local orange = '#DC8F58'
            return {
              ['LineNrAbove'] = { fg = colors.surface1 },
              ['LineNr'] = { fg = orange },
              ['LineNrBelow'] = { fg = colors.surface1 },
            }
          end,
          frappe = function()
            local pink = '#DC67A0'
            return {
              ['@comment'] = { fg = pink },
            }
          end,
        },
      }
    end,
  },
}
