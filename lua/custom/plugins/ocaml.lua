return {
  'tarides/ocaml.nvim',
  config = function()
    require('ocaml').setup {
      params = {
        client = 'ocamllsp',
      },
      keymaps = {
        -- jump_next_hole = '<leader>n',
        -- jump_prev_hole = '<leader>p',
        construct = '<leader>c',
        -- jump = '<leader>j',
        -- phrase_prev = '<leader>pp',
        -- phrase_next = '<leader>pn',
        infer = '<leader>i',
        switch_ml_mli = '<leader>s',
        -- type_enclosing = '<leader>t',
        -- type_enclosing_grow = '<Up>',
        -- type_enclosing_shrink = '<Down>',
        -- type_enclosing_decrease = '<Left>',
        -- type_enclosing_increase = '<Right>',
      },
    }
  end,
}
