return {
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {
      max_width = 50,
      max_height = 10,
      hint_prefix = 'λ ',
      hint_enable = false,
    },
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
}
