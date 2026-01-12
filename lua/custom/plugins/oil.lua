vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.opt_local.colorcolumn = ''
  end,
})

return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'echasnovski/mini.icons', opts = {} },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<C-r>'] = 'actions.refresh',
          ['<M-h>'] = 'actions.select_split',
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            local folder_skip = { 'dev-tools.locks', 'dune.lock', '_build', 'vendor', 'node_module', 'target' }
            return vim.tbl_contains(folder_skip, name)
          end,
        },
      }

      -- Open parent directory in current window
      vim.keymap.set('n', '<leader>-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>oe', function()
        vim.cmd 'Oil .env'
      end, { desc = '[O]pen .[E]nv file' })
      -- Open parent directory in floating window
      vim.keymap.set('n', '-', require('oil').toggle_float, { desc = 'Open parent directory in floating window' })
    end,
  },
}
