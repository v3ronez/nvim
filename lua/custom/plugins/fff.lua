return {
  'dmtrKovalenko/fff.nvim',
  build = 'cargo build --release',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', opts = {} },
  },
  opts = {},
  keys = {
    {
      '<leader>ff', -- try it if you didn't it is a banger keybinding for a picker
      function()
        require('fff').find_files()
      end,
      desc = '[F]ind [F]ile',
    },
    {
      '<leader>hf',
      function()
        require('fff').find_in_git_root()
      end,
      desc = 'Find files in the current git repository',
    },
    {
      '<leader>fs',
      function()
        require('fff').scan_files()
      end,
      desc = '[F]iles [S]can',
    },
    {
      '<leader>fg',
      function()
        require('fff').live_grep()
      end,
      desc = '[F]iles [S]can',
    },
    {
      'fw',
      function()
        require('fff').live_grep { query = vim.fn.expand '<cword>' }
      end,
      desc = 'Search current word',
    },
  },
  config = function()
    require('fff').setup {
      -- UI dimensions and appearance
      prompt = 'λ ',
      preview = {
        enabled = true,
        max_lines = 100,
        max_size = 1024 * 1024, -- 1MB
      },
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = 'top', -- or 'top'
        preview_position = 'right', -- or 'left', 'right', 'top', 'bottom'
        preview_size = 0.5,
      },
      title = 'Searching...',
      max_results = 60, -- Maximum search results to display
      max_threads = 4, -- Maximum threads for fuzzy search

      keymaps = {
        close = '<Esc>',
        select = '<CR>',
        select_split = '<C-s>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        -- Multiple bindings supported
        move_up = { '<Up>', '<C-p>' },
        move_down = { '<Down>', '<C-n>' },
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
      },
      debug = {
        enabled = false,
        show_scores = false, -- Toggle with F2 or :FFFDebug
        show_file_info = false,
      },
    }
  end,
}
