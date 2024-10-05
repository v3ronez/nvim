return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Neo-tree',
        highlight = 'Directory',
        text_align = 'left',
      },
    },
  },
}
