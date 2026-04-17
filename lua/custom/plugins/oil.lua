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
          ['cc'] = {
            desc = 'Copy filepath to system clipboard',
            callback = function()
              require('oil.actions').copy_entry_path.callback()
              vim.fn.setreg('+', vim.fn.getreg(vim.v.register))
            end,
          },
        },
        default_file_explorer = true,
        delete_to_trash = true,
        view_options = {
          show_hidden = true,
          case_insensitive = true,
        },
        lsp_file_methods = {
          autosave_changes = true,
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
