return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('monokai-pro').setup {
      styles = {
        comment = { italic = true },
        keyword = { italic = false }, -- any other keyword
        type = { italic = false }, -- (preferred) int, long, char, etc
        storageclass = { italic = false }, -- static, register, volatile, etc
        structure = { italic = false }, -- struct, union, enum, etc
        parameter = { italic = false }, -- parameter pass in function
        annotation = { italic = true },
        tag_attribute = { italic = false }, -- attribute of tag in reactjs
      },
      filter = 'spectrum',
      overridePalette = function(filter)
        return {
          -- "spectrum
          dark2 = '#131313',
          dark1 = '#191919',
          background = '#222222',
          text = '#f7f1ff',
          accent1 = '#fc618d',
          accent2 = '#fd9353',
          accent3 = '#C3E88D',
          accent4 = '#8AA9F9',
          accent5 = '#F78E67',
          accent6 = '#C792EB',
          dimmed1 = '#bab6c0',
          dimmed2 = '#8b888f',
          dimmed3 = '#69676c',
          dimmed4 = '#525053',
          dimmed5 = '#363537',
        }
      end,
      -- overrideScheme = function(cs, p, config, hp)
      --   local cs_override = {}
      --
      --   cs_override.editor = {}
      --   return cs_override
      -- end,
    }
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'monokai-pro',
      callback = function()
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
      end,
    })
  end,
}
