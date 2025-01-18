vim.opt.laststatus = 3 -- Or 3 for global statusline
-- vim.opt.statusline = '   %f %m %= %l:%c λ    '

-- Function to get the current Git branch
local function get_git_branch()
  local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
  return branch ~= '' and branch or 'no-branch'
end

_G.get_git_branch = get_git_branch

-- Set the status line
vim.opt.statusline = '   %f %m %= %l:%c [%{v:lua.get_git_branch()}] λ    '
return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      disable_background = true,
      styles = {
        italic = false,
        base = '#000000', -- Define o fundo como preto
        overlay = '#000000',
        surface = '#000000',
      },
      highlight_groups = {
        --statusLine
        StatusLine = { fg = '#f1f1f1', bg = 'base', blend = 10 },
        StatusLineNC = { fg = 'subtle', bg = 'surface' },
        --statudLine end
        --telescope
        TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
        TelescopeNormal = { bg = 'none' },
        TelescopePromptNormal = { bg = 'base' },
        TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
        TelescopeSelection = { fg = 'text', bg = 'base' },
        TelescopeSelectionCaret = { fg = 'iris', bg = 'iris' },
        --telescope end
      },
    }
    vim.cmd 'colorscheme rose-pine-moon'

    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'none' })
  end,
}
