return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('monokai-pro').setup {
      styles = {
        comment = { italic = true },
        keyword = { italic = false }, -- any other keyword
        type = { italic = false }, -- (preferred) int, long, char, etc
        storageclass = { italic = false }, -- static, register, volatile, etc
        structure = { italic = false }, -- struct, union, enum, etc
        parameter = { italic = false }, -- parameter pass in function
        annotation = { italic = true },
        tag_attribute = { italic = false }, -- attribute of tag in reactjs
      },
      filter = 'spectrum',
      overridePalette = function(filter)
        return { -- "spectrum
          dark2 = '#131313',
          dark1 = '#191919',
          background = '#222222',
          text = '#f7f1ff',
          accent1 = '#fc618d',
          accent2 = '#fd9353',
          accent3 = '#7bd88f',
          accent4 = '#8AA9F9',
          accent5 = '#E99273',
          accent6 = '#948ae3',
          dimmed1 = '#bab6c0',
          dimmed2 = '#8b888f',
          dimmed3 = '#69676c',
          dimmed4 = '#525053',
          dimmed5 = '#363537',
        }
      end,
    }
  end,
}
