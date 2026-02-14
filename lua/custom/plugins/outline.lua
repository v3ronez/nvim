return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<C-b>', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      outline_window = {
        position = 'left',
        width = 35,
        auto_close = false,
        focus_on_open = false,
        relative_width = false,
        no_provider_message = '',
      },
    },
    config = function(_, opts)
      require('outline').setup(opts)
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function()
          local function count_normal_windows()
            local count = 0
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local config = vim.api.nvim_win_get_config(win)
              if config.relative == '' then -- Non-floating windows
                count = count + 1
              end
            end
            return count
          end

          if vim.bo.filetype == 'Outline' and count_normal_windows() == 1 then
            vim.cmd 'q'
          end
        end,
      })
    end,
  },
}
