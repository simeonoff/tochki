return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' },
  enabled = true,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
  },

  config = function()
    local treesitter = require('nvim-treesitter.configs')

    -- Use a fork of the tree-sitter-scss parser for better highlighting
    local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
    parser_configs.scss = {
      install_info = {
        url = 'https://github.com/simeonoff/tree-sitter-scss',
        files = { 'src/parser.c', 'src/scanner.c' },
        revision = '6e0203c789325ad61baa6c4c8bf95db4b2f340ce',
      },
      filetype = 'scss',
    }

    parser_configs.sassdoc = {
      install_info = {
        url = 'https://github.com/simeonoff/tree-sitter-sassdoc',
        files = { 'src/parser.c' },
        revision = 'af8f299e649032b57206679db11f249e62495bd4',
      },
      filetype = 'sassdoc',
    }

    ---@diagnostic disable-next-line: missing-fields
    treesitter.setup({
      ignore_install = {
        'help',
      },
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- disable = { "scss" },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'Select the outer part of a function/method' },
            ['if'] = { query = '@function.inner', desc = 'Select the inner part of a function/method' },
            ['ab'] = { query = '@block.outer', desc = 'Select the outer part of a code block' },
            ['ib'] = { query = '@block.inner', desc = 'Select the inner part of a code block' },
            ['ac'] = { query = '@call.outer', desc = 'Select the outer part of a cal' },
            ['ic'] = { query = '@call.inner', desc = 'Select the inner part of a call' },
            ['a='] = { query = '@assignment.outer', desc = 'Select the outer part of an assignment' },
            ['i='] = { query = '@assignment.inner', desc = 'Select the inner part of an assignment' },
            -- ["l="] = { query = "@assignment.lhs", desc = "Select the lhs of an assignment" },
            -- ["r="] = { query = "@assignment.rhs", desc = "Select the lhs of an assignment" },
          },
        },
      },
      ensure_installed = {
        'astro',
        'angular',
        'bash',
        'diff',
        'go',
        'gomod',
        'help',
        'javascript',
        'typescript',
        'tsx',
        'html',
        'c_sharp',
        'css',
        'scss',
        'json',
        'jsonc',
        'jsdoc',
        'regex',
        'lua',
        'nu',
        'nix',
        'razor',
        'svelte',
        'tmux',
        'yaml',
        'help',
        'hyprlang',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
      },
      indent = {
        enable = false,
      },
      autotag = {
        enable = true,
      },
    })
  end,
}
