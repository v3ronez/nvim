vim.opt.grepprg = "rg --vimgrep --hidden --glob '!target'"
--
vim.opt.ignorecase = true
vim.opt.wildignore:append {
  '*.o',
  '*.obj',
  '*.exe',
  '*.dll',
  '*.pyc',
  '*.pyo',
  '*.so',
  '*.jpg',
  '*.jpeg',
  '*.png',
  '*.gif',
  '*.zip',
  '*.tar.gz',
  '*.rar',
  '*.tar.bz2',
  '*node_modules/*',
  '*.DS_Store',
  '*.git',
  '*.hg',
  '*.svn',
  '*/vendor/*',
  'target/*', -- Rust's build directory
  '*.rs.bk', -- Rust backup files, if any
}
-- vim.opt.autoread = true
-- -- vim.opt.number = true
-- vim.opt.relativenumber = true
-- vim.cmd.hi 'Comment gui=none'
-- vim.opt.mouse = 'a'
-- vim.opt.showmode = false
-- vim.opt.updatetime = 50
-- vim.opt.termguicolors = true
-- -- Enable break cndent
-- vim.opt.breakindent = true
-- -- Save undo history
-- vim.opt.undofile = true
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
--
-- vim.opt.signcolumn = 'yes'
--
-- vim.opt.updatetime = 250
--
-- vim.opt.timeoutlen = 300
--
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
--
-- -- Sets how neovim will display certain whitespace characters in the editor.
-- --  See `:help 'list'`
-- --  and `:help 'listchars'`
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
--
-- vim.opt.inccommand = 'split'
--
-- vim.opt.cursorline = true
-- vim.opt.smartindent = true
-- vim.opt.guicursor = ""

vim.opt.list = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append '@-@'

vim.opt.updatetime = 50

return {}
