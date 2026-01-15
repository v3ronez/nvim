return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
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
      }
      local palette = require('catppuccin.palettes').get_palette 'macchiato'

      -- Telescope highlights to match editor background
      -- vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = palette.blue, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = palette.blue, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = palette.blue, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = palette.blue, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = palette.mauve, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = palette.mauve, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = palette.mauve, bg = palette.base })
      -- vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = palette.mauve, bg = palette.base })

      -- -- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
      -- for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
      --   vim.api.nvim_set_hl(0, group, {})
      -- end
    end,
  },
}
