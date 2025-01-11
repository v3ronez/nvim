vim.opt.grepprg = "rg --vimgrep --hidden --glob '!target'"

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
vim.opt.autoread = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd.hi 'Comment gui=none'
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.updatetime = 50

vim.opt.termguicolors = true
-- Enable break cndent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true
vim.opt.smartindent = true
return {}
