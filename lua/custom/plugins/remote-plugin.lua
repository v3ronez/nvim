return {
  {
    'amitds1997/remote-nvim.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      client_callback = function(port, workspace_config)
        local cmd = ('wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s'):format(
          port,
          ("'Remote: %s'"):format(workspace_config.host)
        )
        if vim.env.TERM == 'xterm-kitty' then
          cmd = ('kitty -e nvim --server localhost:%s --remote-ui'):format(port)
        end
        vim.fn.jobstart(cmd, {
          detach = true,
          on_exit = function(job_id, exit_code, event_type)
            print('Client', job_id, 'exited with code', exit_code, 'Event type:', event_type)
          end,
        })
      end,
    },
  },
}
