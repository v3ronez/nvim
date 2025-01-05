local map = vim.api.nvim_set_keymap
vim.api.nvim_create_user_command('SaveWithoutFormatUpdate', function()
  vim.cmd 'update'
end, {})
map('n', '<Leader>su', ':SaveWithoutFormatUpdate<CR>', { noremap = true, silent = true, desc = 'Salva sem formatação (update)' })
