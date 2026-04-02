local add = vim.pack.add
local later = Config.later

later(function()
  add({
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1.9.1' },
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/folke/lazydev.nvim',
  })

  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  })

  require('blink.cmp').setup({
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    signature = {
      enabled = true,
    },
    keymap = {
      preset = 'default',
      -- Prefer LSP inline completion (e.g. Copilot) over menu completion.
      -- If an inline suggestion is visible, accept it; otherwise fall through
      -- to blink's select_and_accept.
      ['<C-y>'] = { 'select_and_accept' },
    },
    cmdline = {
      keymap = {
        preset = 'inherit',
      },
    },

    enabled = function() return not vim.tbl_contains({ 'oil', 'markdown' }, vim.bo.filetype) end,

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      ghost_text = {
        enabled = false,
      },
      menu = {
        border = 'single',
        draw = {
          columns = {
            { 'kind_icon', 'label', gap = 1 },
            { 'source_name' },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                local dev_icon = require('kind').get_icon(ctx.kind)

                if dev_icon then icon = dev_icon end

                return icon .. ctx.icon_gap
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        window = { border = 'single' },
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lazydev', 'lsp', 'buffer', 'snippets', 'path' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          -- Make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        lsp = {
          min_keyword_length = 0, -- Number of characters to trigger provider
          score_offset = 5, -- Boost/penalize the score of the items
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.client_name ~= 'copilot'
            end, items)
          end,
        },
        path = {
          min_keyword_length = 0,
        },
        snippets = {
          min_keyword_length = 2,
          score_offset = 0,
        },
        -- copilot = {
        --   name = 'copilot',
        --   module = 'blink-copilot',
        --   score_offset = 100,
        --   async = true,
        -- },
        buffer = {
          min_keyword_length = 4,
          max_items = 5,
        },
      },
    },
    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      sorts = {
        function(a, b)
          if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then return end
          return b.client_name == 'emmetls'
        end,
        -- 'exact',
        -- defaults
        'score',
        'sort_text',
        'kind',
      },
      implementation = 'prefer_rust',
    },
    prebuilt_binaries = {
      download = true,
    },
  })
end)
