return {
  -- toggleterm
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = 55,
      open_mapping = [[<C-t>]],
      direction = 'vertical',
      shading_factor = '5',
    }

    -- Counts the number of terminals that exist
    function CountTerms()
      local buffers = vim.api.nvim_list_bufs()
      local terminal_count = 0

      for _, buf in ipairs(buffers) do
        if vim.bo[buf].buftype == 'terminal' then
          terminal_count = terminal_count + 1
        end
      end
      return terminal_count
    end

    -- Create new terminals
    vim.keymap.set('n', '<leader>tt', function()
      local command = CountTerms() + 1 .. 'ToggleTerm direction=vertical size=55'
      vim.cmd(command)
    end, { noremap = true, silent = true, desc = 'New ToggleTerm' })

    -- Close current terminal
    vim.keymap.set('n', '<leader>te', function()
      if CountTerms() == 0 then
        return
      end
      vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
    end, { noremap = true, silent = true, desc = 'Exits current ToggleTerm' })
  end,
}
