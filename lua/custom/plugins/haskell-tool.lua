return {
  'mrcjkb/haskell-tools.nvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function()
    vim.g.haskell_tools = {
      hls = {
        settings = {
          haskell = {
            formattingProvider = 'stylish-haskell',
            plugin = {
              class = { -- missing class methods
                codeLensOn = false,
              },
              importLens = { -- make import lists fully explicit
                codeLensOn = false,
              },
              refineImports = { -- refine imports
                codeLensOn = false,
              },
              tactics = { -- wingman
                codeLensOn = false,
              },
              moduleName = { -- fix module names
                globalOn = false,
              },
              eval = { -- evaluate code snippets
                globalOn = false,
              },
              ['ghcide-type-lenses'] = { -- show/add missing type signatures
                globalOn = true,
              },
            },
          },
        },
      },
    }
  end,
}
