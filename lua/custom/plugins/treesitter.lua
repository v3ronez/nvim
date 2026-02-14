return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        max_lines = 1,
      },
    },
  },
  config = function()
    require('nvim-treesitter').setup {
      ensure_installed = {
        'c',
        'cpp',
        'go',
        'lua',
        'python',
        'rust',
        'tsx',
        'vimdoc',
        'vim',
        'markdown',
        'wgsl',
        'html',
        'vue',
        'php',
        'phpdoc',
        'php_only',
        'typescript',
        'typescriptreact',
        'javascript',
        'javascriptreact',
        'json',
        'jsonc',
        'yaml',
        'blade',
        'toml',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },
    }
  end,
}
