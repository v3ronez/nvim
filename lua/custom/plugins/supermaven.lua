return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<C-k>',
        clear_suggestion = '<C-]>',
        accept_word = '<C-j>',
      },
    }
    vim.keymap.set('n', '<leader>at', '<CMD>SupermavenToggle<CR>', { desc = '[A]I [T]oggle' })
  end,
}
