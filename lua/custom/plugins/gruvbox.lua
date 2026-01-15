return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  config = function()
    require('gruvbox').setup {
      terminal_colors = false,
      undercurl = true,
      underline = true,
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
      inverse = false, -- invert background for search, diffs, statuslines and errors
      contrast = 'soft', -- can be "hard", "soft" or empty string
      palette_overrides = {
        light0 = '#F5E6D3',
      },
      overrides = {
        -- -- Normal = { bg = '#111022' },
        -- LspReferenceText = { fg = 'None', bg = '#49433E' },
        -- LspReferenceWrite = { fg = 'None', bg = '#49433E' },
        -- LspReferenceRead = { fg = 'None', bg = '#49433E' },
        -- -- Operator = { fg = '#cf5c48' },
        -- Search = { fg = '#1d2021', bg = '#fabd2f' },
        -- IncSearch = { fg = '#1d2021', bg = '#fabd2f' },
        -- -- String = { fg = '#bee289' },

        -- dark
        -- LineNrAbove = { fg = '#7c6f64' },
        -- LineNr = { fg = '#EBC06D' },
      },
      dim_inactive = false,
      transparent_mode = false,

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'gruvbox',
        callback = function()
          if vim.o.background == 'dark' then
            vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#69676c' })
            vim.api.nvim_set_hl(0, 'LineNr', { fg = '#F88B64' })
            vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#69676c' })

            vim.api.nvim_set_hl(0, '@type.builtin', { fg = '#9586E1', italic = false })
            vim.api.nvim_set_hl(0, '@type', { fg = '#F78E67', italic = false })
            vim.api.nvim_set_hl(0, '@keyword.function', { fg = '#F78E67', italic = false })
            vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#f7f1ff', italic = false })
            vim.api.nvim_set_hl(0, '@keyword.type', { fg = '#F78E67', italic = false })
            vim.api.nvim_set_hl(0, '@keyword', { fg = '#F78E67', italic = false })
            vim.api.nvim_set_hl(0, '@variable.builtin', { fg = '#8AA9F9', italic = false })
            vim.api.nvim_set_hl(0, '@comment', { fg = '#E2C765', italic = false })
          else
            vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#DC8F58' })
            vim.api.nvim_set_hl(0, 'LineNr', { fg = '#D17A3A' })
            vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#DC8F58' })

            vim.api.nvim_set_hl(0, '@comment', { fg = '#D14C8C', italic = true })
            vim.api.nvim_set_hl(0, '@variable', { fg = '#3D3D3D', italic = false })
            vim.api.nvim_set_hl(0, 'IncSearch', {
              bg = '#5B9FB5',
            })
          end
        end,
      }),
    }
  end,
}
