return {
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      hint_prefix = '',
      max_width = 50,
      hint_enable = false,
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
}
