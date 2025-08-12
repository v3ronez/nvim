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
      '<leader>hf', -- try it if you didn't it is a banger keybinding for a picker
      function()
        require('fff').find_in_git_root()
      end,
      desc = 'Find files in the current git repository',
    },
  },
  config = function()
    require('fff').setup {
      -- UI dimensions and appearance
      width = 0.8, -- Window width as fraction of screen
      height = 0.9, -- Window height as fraction of screen
      prompt = 'λ ',
      preview = {
        enabled = true,
        width = 0.5,
        max_lines = 100,
        max_size = 1024 * 1024, -- 1MB
      },
      title = 'FFF Files',
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
        show_scores = true, -- Toggle with F2 or :FFFDebug
      },
    }
  end,
}
