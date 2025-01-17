return {
  'ccaglak/larago.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  --keymaps
  vim.keymap.set('n', '<leader>gf', '<cmd>GoBlade<cr>', { desc = 'Go to blade file' }),
}
