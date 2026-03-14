return {
  'datsfilipe/vesper.nvim',
  config = function()
    require('vesper').setup {
      italics = {
        comments = false, -- Boolean: Italicizes comments
        keywords = false, -- Boolean: Italicizes keywords
        functions = false, -- Boolean: Italicizes functions
        strings = false, -- Boolean: Italicizes strings
        variables = false, -- Boolean: Italicizes variables
      },
      overrides = {
        Constant = { fg = '#FFCFA8' },
      },
    }
  end,
}
