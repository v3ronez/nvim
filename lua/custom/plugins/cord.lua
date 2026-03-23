return {
  'vyfor/cord.nvim',
  config = function()
    local cwd = vim.fn.getcwd()
    local disabled = cwd:match '^/Users/veronez/code/work'
    require('cord').setup {
      enabled = not disabled,
    }
  end,
}
