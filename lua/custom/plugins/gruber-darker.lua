return {
  'thimc/gruber-darker.nvim',
  config = function()
    require('gruber-darker').setup {
      -- OPTIONAL
      transparent = false, -- removes the background
      -- underline = false, -- disables underline fonts
      -- bold = false, -- disables bold fonts
    }
  end,
}
