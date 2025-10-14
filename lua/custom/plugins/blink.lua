return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      config = function()
        local luasnip = require 'luasnip'

        -- Loads all the snippets installed by extensions in vscode.
        -- require('luasnip.loaders.from_vscode').lazy_load()
        require('luasnip.loaders.from_vscode').lazy_load {
          exclude = { 'css' },
          require('luasnip.loaders.from_snipmate').load { path = { './snippets/*' } },
        }
        luasnip.config.set_config {
          region_check_events = 'InsertEnter',
          delete_check_events = 'InsertLeave',
          -- history = true,
          -- region_check_events = 'InsertEnter',
          -- delete_check_events = 'TextChanged,InsertLeave',
        }

        luasnip.config.setup {}
      end,
    },
    {
      'saghen/blink.compat',
      version = '2.*',
      lazy = true,
      opts = {},
    },
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- v3config :D
    keymap = {
      preset = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-h>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    signature = { enabled = true },
    snippets = { preset = 'luasnip' },
    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = {
        auto_show = true,
      },
      -- list = {
      --   selection = {
      --     preselect = true,
      --     auto_insert = true,
      --   },
      -- },
      --   menu = {
      --     draw = {
      --       -- Controls how the completion items are rendered on the popup window
      --       -- Aligns the keyword you've typed to a component in the menu
      --       align_to = 'label', -- or 'none' to disable, or 'cursor' to align to the cursor
      --       -- Left and right padding, optionally { left, right } for different padding on each side
      --       padding = 1,
      --       -- Gap between columns
      --       -- gap = 1,
      --       -- Use treesitter to highlight the label text for the given list of sources
      --       treesitter = { 'lsp' },
      --
      --       -- Components to render, grouped by column
      --       -- columns = { { 'kind_icon', gap = 1 }, { 'label' }, { 'kind' } },
      --       -- components = {
      --       --   kind = {
      --       --     ellipsis = false,
      --       --     width = { fill = true },
      --       --     text = function(ctx)
      --       --       return ctx.kind
      --       --     end,
      --       --     highlight = function(ctx)
      --       --       return ctx.kind_hl
      --       --     end,
      --       --   },
      --       --   label = {
      --       --     width = { fill = true, max = 30 },
      --       --     text = function(ctx)
      --       --       return ctx.label .. ' ' .. ctx.label_detail
      --       --     end,
      --       --     highlight = function(ctx)
      --       --       -- label and label details
      --       --       local highlights = {
      --       --         { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
      --       --       }
      --       --       if ctx.label_detail then
      --       --         table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
      --       --       end
      --       --
      --       --       -- characters matched on the label by the fuzzy matcher
      --       --       for _, idx in ipairs(ctx.label_matched_indices) do
      --       --         table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
      --       --       end
      --       --
      --       --       return highlights
      --       --     end,
      --       --   },
      --       --   label_description = {
      --       --     width = { max = 30 },
      --       --     text = function(ctx)
      --       --       return ctx.label_description
      --       --     end,
      --       --     highlight = 'BlinkCmpLabelDescription',
      --       --   },
      --       -- },
      --     },
      --   },
    },
    --
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`

    sources = {
      default = { 'lsp', 'laravel', 'snippets', 'path', 'lazydev' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        laravel = {
          name = 'laravel',
          module = 'blink.compat.source',
          score_offset = 95, -- show at a higher priority than lsp
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
