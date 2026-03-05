local add = vim.pack.add
local now_if_args = Config.now_if_args

now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  local languages = {
    'astro',
    'angular',
    'bash',
    'diff',
    'go',
    'gomod',
    'javascript',
    'typescript',
    'tsx',
    'html',
    'c_sharp',
    'css',
    'scss',
    'sassdoc',
    'json',
    'jsdoc',
    'regex',
    'lua',
    'nu',
    'nix',
    'razor',
    'svelte',
    'tmux',
    'yaml',
    'hyprlang',
    'markdown',
    'markdown_inline',
    'vim',
    'vimdoc',
  }

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/windwp/nvim-ts-autotag',
  })

  -- Tree-sitter
  require('nvim-treesitter').setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
  })

  -- Add nvim-treesitter's bundled queries (e.g. indents.scm for lua) to the
  -- runtime path. These live under the plugin's runtime/ subdirectory which
  -- is not automatically added by :packadd.
  local ts_mod = vim.api.nvim_get_runtime_file('lua/nvim-treesitter/init.lua', false)[1]
  if ts_mod then
    -- lua/nvim-treesitter/init.lua -> plugin root -> runtime/
    local ts_runtime = vim.fs.joinpath(vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(ts_mod))), 'runtime')
    if vim.uv.fs_stat(ts_runtime) and not vim.list_contains(vim.opt.rtp:get(), ts_runtime) then
      vim.opt.rtp:prepend(ts_runtime)
    end
  end

  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}

  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')

  local ts_custom_languages = function()
    local parsers = require('nvim-treesitter.parsers')

    parsers.scss = {
      install_info = {
        url = 'https://github.com/simeonoff/tree-sitter-scss',
        files = { 'src/parser.c', 'src/scanner.c' },
        revision = '0bbe7605859345f34674ccd6a66a45963c2ff911',
        queries = 'queries',
      },
    }

    parsers.sassdoc = {
      install_info = {
        url = 'https://github.com/simeonoff/tree-sitter-sassdoc',
        files = { 'src/parser.c' },
        revision = '2778a1537a6158f26a3bde8de70280aaf8b1fdea',
        queries = 'queries/sassdoc',
      },
    }
  end

  Config.new_autocmd('User', 'TSUpdate', ts_custom_languages, 'Set up tree-sitter custom languages')

  -- Tree-sitter TextObjects
  require('nvim-treesitter-textobjects').setup({
    select = {
      lookahead = true,
    },
  })

  -- Tree-sitter autotaging for languages like HTML
  require('nvim-ts-autotag').setup()
end)
