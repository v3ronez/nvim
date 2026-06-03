return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup {
      options = {
        styles = {
          -- keywords = 'bold',
          -- types = 'bold',
        },
      },
    }

    local _colorscheme = 'github_light'
    local _background = 'light'

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        if vim.g.colors_name ~= nil then
          _colorscheme = vim.g.colors_name
          _background = vim.o.background
        end
      end,
    })

    vim.api.nvim_create_autocmd('ColorSchemePre', {
      callback = function()
        vim.schedule(function()
          if vim.g.colors_name == nil then
            vim.o.background = _background
            vim.cmd.colorscheme(_colorscheme)
          end
        end)
      end,
    })
  end,
}
