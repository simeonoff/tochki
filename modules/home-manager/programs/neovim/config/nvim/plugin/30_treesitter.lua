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
    'comment',
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
    'rust',
    'svelte',
    'tmux',
    'yaml',
    'hyprlang',
    'markdown',
    'markdown_inline',
    'query',
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

  local ts_custom_languages = function()
    local parsers = require('nvim-treesitter.parsers')

    -- Own parsers: build from the local checkout when it exists (development
    -- on the Mac), otherwise from GitHub at a pinned revision (e.g. servers).
    local source = function(path, url, revision)
      if vim.uv.fs_stat(vim.fn.expand(path)) then return { path = path } end
      return { url = url, revision = revision }
    end

    parsers.scss = {
      install_info = vim.tbl_extend(
        'force',
        source('~/Projects/tree-sitter-scss', 'https://github.com/simeonoff/tree-sitter-scss', 'db0072fc9af1a2b488b646b4e6360e96541f495d'),
        { files = { 'src/parser.c', 'src/scanner.c' }, queries = 'queries' }
      ),
    }

    parsers.sassdoc = {
      install_info = vim.tbl_extend(
        'force',
        source('~/Projects/tree-sitter-sassdoc', 'https://github.com/simeonoff/tree-sitter-sassdoc', '38abe86eac15ed8d668de04df963ef0a4c220cfe'),
        { files = { 'src/parser.c' }, queries = 'queries/sassdoc' }
      ),
    }
  end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}

  -- Register custom parsers now so their filetypes are available for the loop below,
  -- and again after TSUpdate so they survive parser reinstalls.
  ts_custom_languages()

  -- install() reloads the parser table and fires `User TSUpdate`, so the
  -- custom parsers must be re-registered from that event. Subscribe before
  -- installing, otherwise they are dropped and reported as unsupported.
  Config.new_autocmd('User', 'TSUpdate', ts_custom_languages, 'Set up tree-sitter custom languages')

  -- Install missing parsers. Skip names nvim-treesitter doesn't know (e.g.
  -- tmux, dropped upstream) instead of warning about them on every start.
  local available = require('nvim-treesitter.parsers')
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local is_available = function(lang) return available[lang] ~= nil end
  local to_install = vim.tbl_filter(
    function(lang) return isnt_installed(lang) and is_available(lang) end,
    languages
  )
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- MDX highlighting: treat MDX as markdown and rely on query injections.
  vim.treesitter.language.register('markdown', 'mdx')

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

  -- Tree-sitter TextObjects
  require('nvim-treesitter-textobjects').setup({
    select = {
      lookahead = true,
    },
  })

  -- Tree-sitter autotaging for languages like HTML
  require('nvim-ts-autotag').setup()
end)
