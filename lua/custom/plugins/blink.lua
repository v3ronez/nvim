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
        local s = luasnip.snippet
        local i = luasnip.insert_node
        local t = luasnip.text_node
        local c = luasnip.choice_node

        local default_js_snippets = {
          s('log', {
            t 'console.log(',
            i(1, 'expression'),
            t ');',
          }),
          s('ar', {
            i(1, 'param'),
            t ' => {',
            i(2, 'body'),
            t '\n}',
          }),
        }

        luasnip.add_snippets('vue', default_js_snippets)
        luasnip.add_snippets('javascript', default_js_snippets)
        luasnip.add_snippets('typescript', default_js_snippets)

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
    signature = {
      enabled = true,
      trigger = {
        show_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
      },
      window = {
        border = 'rounded',
        show_documentation = true,
      },
    },
    snippets = { preset = 'luasnip' },
    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      trigger = {
        show_on_trigger_character = true,
      },
      menu = {
        border = 'rounded',
        max_height = 10,
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
          },
          components = {
            -- Native icon support (no lspkind needed)
            source_name = {
              text = function(ctx)
                local source_names = {
                  lsp = '[LSP]',
                  buffer = '[Buffer]',
                  path = '[Path]',
                  snippets = '[Snippet]',
                }
                return (source_names[ctx.source_name] or '[') .. ctx.source_name .. ']'
              end,
              highlight = 'CmpItemMenu',
            },
          },
        },
        auto_show = true,
      },
      documentation = {
        auto_show = true,
        window = {
          border = 'rounded',
        },
      },
      ghost_text = {
        enabled = false,
      },
      list = {
        selection = {
          preselect = true,
        },
      },
    },
    --
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`

    sources = {
      default = { 'lsp', 'laravel', 'snippets', 'path' },
      providers = {
        lsp = {
          score_offset = 1000, -- Extreme priority to override fuzzy matching
        },
        laravel = {
          name = 'laravel',
          module = 'blink.compat.source',
          score_offset = 100,
        },
        path = {
          score_offset = 60, -- File paths moderate priority
        },
        snippets = {
          score_offset = -100, -- Much lower priority
          max_items = 2, -- Limit snippet suggestions
          min_keyword_length = 2, -- Don't show for single chars
        },
        buffer = {
          score_offset = -150, -- Lowest priority
          min_keyword_length = 3, -- Only show after 3 chars
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
