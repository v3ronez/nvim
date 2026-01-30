return {
  'abreujp/scholar.nvim',
  priority = 1000,
  config = function()
    require('scholar').setup {
      -- your configuration here
    }
  end,
}
