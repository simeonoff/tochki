local add = vim.pack.add
local now, later, autocmd = Config.now, Config.later, Config.new_autocmd
local bufonly = require('bufonly')

later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  -- Use conform.nvim for formatting
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  -- Format the current buffer using conform.nvim
  vim.api.nvim_create_user_command('Format', function(args)
    local range = nil

    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

      range = {
        start = { args.line1, 0 },
        ['end'] = { args.line2, end_line:len() },
      }
    end

    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
  end, { range = true })

  require('conform').setup({
    formatters_by_ft = {
      astro = { 'prettierd' },
      lua = { 'stylua' },
      javascript = { 'prettierd' },
      typescript = { 'biome', 'prettierd', stop_after_first = true },
      typescriptreact = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      css = { 'biome', 'prettierd', 'stylelint' },
      scss = { 'prettierd', 'stylelint' },
      html = { 'prettierd' },
      json = { 'biome', 'prettierd' },
      jsonc = { 'biome', 'prettierd' },
      md = { 'prettierd' },
      mdx = { 'prettierd' },
      yaml = { 'prettierd' },
      svelte = { 'prettierd' },
      go = { 'goimports' },
      nix = { 'nixpkgs_fmt' },
    },
  })
end)

later(function()
  add({ 'https://github.com/folke/flash.nvim.git' })

  require('flash').setup({
    prompt = {
      enabled = false,
      prefix = { { ' ', 'FlashPromptIcon' } },
      win_config = {
        relative = 'editor',
        width = 1,
        height = 1,
        row = -1,
        col = 0,
        zindex = 1000,
      },
    },
  })
end)

later(function()
  add({ 'https://github.com/folke/trouble.nvim.git' })

  local trouble = require('trouble')
  local kind_icons = require('kind').icons

  trouble.setup({
    icons = {
      indent = {
        fold_closed = '+ ',
        fold_open = '- ',
      },
      kinds = kind_icons,
    },
  })

  vim.keymap.set(
    'n',
    '<leader>tt',
    function() trouble.toggle({ mode = 'diagnostics' }) end,
    { desc = 'Toggle Trouble' }
  )

  vim.keymap.set(
    'n',
    '<leader>tn',
    function()
      trouble.next({
        skip_groups = true,
        jump = true,
      })
    end,
    { desc = 'Go to next trouble' }
  )

  vim.keymap.set(
    'n',
    '<leader>tp',
    function()
      trouble.previous({
        skip_groups = true,
        jump = true,
      })
    end,
    { desc = 'Go to previous trouble' }
  )
end)

-- Dial allows you to increment and decrement various types of values, such as numbers, dates, boolean values, and more.
later(function()
  add({ 'https://github.com/monaqa/dial.nvim.git' })

  local augend = require('dial.augend')

  require('dial.config').augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.bool,
      augend.semver.alias.semver,
    },
  })

  vim.keymap.set(
    'n',
    '<C-a>',
    function() return require('dial.map').inc_normal() end,
    { expr = true, desc = 'Increment' }
  )

  vim.keymap.set(
    'n',
    '<C-x>',
    function() return require('dial.map').dec_normal() end,
    { expr = true, desc = 'Decrement' }
  )
end)

-- Linting plugin. It allows you to lint your code using various linters.
later(function()
  add({ 'https://github.com/mfussenegger/nvim-lint.git' })

  local lint = require('lint')

  -- Custom ast-grep linter for language injection rules (e.g. sassdoc in SCSS).
  -- The ast-grep LSP does not support language injection — only the CLI does.
  -- This linter runs `ast-grep scan --json=stream` on the saved file and parses
  -- the JSON output into vim diagnostics.
  local severity_map = {
    error = vim.diagnostic.severity.ERROR,
    warning = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hint = vim.diagnostic.severity.HINT,
  }

  lint.linters.ast_grep = {
    cmd = 'ast-grep',
    stdin = false,
    append_fname = true,
    args = { 'scan', '--json=stream' },
    stream = 'stdout',
    ignore_exitcode = true,
    parser = function(output)
      local diagnostics = {}
      local seen = {}
      local lines = vim.split(output, '\n', { trimempty = true })

      for _, line in ipairs(lines) do
        local ok, decoded = pcall(vim.json.decode, line)

        if ok and decoded.range then
          -- Deduplicate: ast-grep injection can produce duplicate matches.
          local key = string.format(
            '%s:%d:%d:%d:%d',
            decoded.ruleId or '',
            decoded.range.start.line,
            decoded.range.start.column,
            decoded.range['end'].line,
            decoded.range['end'].column
          )

          if not seen[key] then
            seen[key] = true

            table.insert(diagnostics, {
              lnum = decoded.range.start.line,
              col = decoded.range.start.column,
              end_lnum = decoded.range['end'].line,
              end_col = decoded.range['end'].column,
              message = decoded.message or '',
              code = decoded.ruleId,
              user_data = {
                lsp = { code = decoded.ruleId },
              },
              severity = severity_map[decoded.severity] or vim.diagnostic.severity.WARN,
              source = 'ast-grep',
            })
          end
        end
      end

      return diagnostics
    end,
  }

  --- Find the nearest ancestor directory containing sgconfig.yml or sgconfig.yaml.
  ---@param bufnr integer
  ---@return string|nil root directory path, or nil if not found
  local function find_ast_grep_root(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == '' then return nil end

    local roots = vim.fs.find(
      { 'sgconfig.yml', 'sgconfig.yaml' },
      { path = vim.fs.dirname(fname), upward = true, limit = 1 }
    )

    if #roots > 0 then return vim.fs.dirname(roots[1]) end

    return nil
  end

  -- Register linters by filetype (ast_grep excluded — it needs special cwd handling)
  lint.linters_by_ft = {
    go = {},
    lua = {},
  }

  -- Listen for file writes and lint
  vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
    callback = function()
      -- Run standard linters for the current filetype
      lint.try_lint()

      -- Run ast-grep linter for filetypes that have injection rules,
      -- but only when inside a project with sgconfig.yml
      local ft = vim.bo.filetype

      if ft == 'scss' then
        local root = find_ast_grep_root(vim.api.nvim_get_current_buf())

        if root then lint.try_lint('ast_grep', { cwd = root }) end
      end
    end,
  })
end)

later(function() add({ 'https://github.com/dhruvasagar/vim-table-mode.git' }) end)

-- Markdown preview plugin. It allows you to preview markdown files in the browser.
later(function()
  local mkdp_handler = function() vim.fn['mkdp#util#install']() end
  Config.on_packchanged('markdown-preview.nvim', { 'install', 'update' }, mkdp_handler, ':MkdpInstall')
  vim.g.mkdp_auto_start = 0

  add({ 'https://github.com/iamcco/markdown-preview.nvim.git' })
end)

-- Visualize and work with indent scope. It visualizes indent scope "at cursor"
-- with animated vertical line. Provides relevant motions and textobjects.
-- Example usage:
-- - `cii` - *c*hange *i*nside *i*ndent scope
-- - `Vaiai` - *V*isually select *a*round *i*ndent scope and then again
--   reselect *a*round new *i*indent scope
-- - `[i` / `]i` - navigate to scope's top / bottom
--
-- See also:
-- - `:h MiniIndentscope.gen_animation` - available animation rules
later(
  function()
    require('mini.indentscope').setup({
      symbol = '│',
      draw = {
        animation = require('mini.indentscope').gen_animation.none(),
      },
    })
  end
)

-- Command line tweaks. Improves command line editing with:
-- - Autocompletion. Basically an automated `:h cmdline-completion`.
-- - Autocompletion is handled by blink.cmp and is disabled here.
-- - Autocorrection of words as-you-type. Like `:W`->`:w`, `:lau`->`:lua`, etc.
-- - Autopeek command range (like line number at the start) as-you-type.
later(function()
  require('mini.cmdline').setup({
    autocomplete = {
      enabled = false,
    },
  })
end)

-- Pressing q closes the quickfix, help and other windows
later(function()
  autocmd('FileType', {
    'qf',
    'help',
    'man',
    'notify',
    'oil',
    'nvim-undotree',
  }, function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end)

  -- Turn on spellcheck for markdown files
  autocmd('FileType', 'markdown', function() vim.opt.spell = true end)

  -- Add `BufOnly` command to delete all buffers except the current one
  vim.api.nvim_create_user_command('BufOnly', bufonly.BufOnly, { desc = 'Delete all buffers except the current one' })
end)

-- Clean up unused plugins. It checks for inactive plugins and prompts the user to remove them.
-- Inactive plugins are those that are not currently active in the Neovim session, which can happen if they were removed from the configuration but still exist in the plugin directory.
-- This command helps keep the plugin directory clean and free of unused plugins.
later(function()
  local function pack_clean()
    local inactive = vim.tbl_filter(function(p) return not p.active end, vim.pack.get())

    if #inactive == 0 then
      vim.notify('No inactive plugins found.', vim.log.levels.INFO)
      return
    end

    local names = vim.tbl_map(function(p) return p.spec.name end, inactive)
    local choice = vim.fn.confirm('Remove ' .. #names .. ' unused plugin(s)?', '&Yes\n&No', 2)
    if choice == 1 then vim.pack.del(names) end
  end

  vim.keymap.set('n', '<leader>px', pack_clean)
end)

now(function()
  require('mini.starter').setup({
    header = function()
      local banner = require('banners').modern_v1
      local quotes = require('quotes')

      math.randomseed(os.time())
      local quote = quotes[math.random(#quotes)]

      return banner .. '\n' .. require('utils').format_quote(quote, { author_newline = false })
    end,
    items = {
      { action = 'ene | startinsert', name = 'New File', section = 'Actions' },
      { action = 'Oil .', name = 'Browse Files', section = 'Actions' },
      { action = 'FindFiles', name = 'Find Files', section = 'Actions' },
      { action = 'RecentFiles', name = 'Recent Files', section = 'Actions' },
      { action = 'FindText', name = 'Live Grep', section = 'Actions' },
      { action = 'ConfigFiles', name = 'Config', section = 'Editor' },
      { action = 'qa', name = 'Quit', section = 'Editor' },
    },
    footer = function()
      local version = vim.system({ 'nvim', '--version' }):wait().stdout
      local first_line = version and version:match('^(.-)\n')

      return first_line or 'Neovim'
    end,
    content_hooks = {
      require('mini.starter').gen_hook.aligning('center', 'center'),

      function(content)
        for _, line in ipairs(content) do
          for _, unit in ipairs(line) do
            if unit.type == 'footer' then unit.hl = 'WinSeparator' end
          end
        end

        return content
      end,
    },
  })
end)

-- Undotree visualizes the undo history and allows you to navigate through it.
-- It provides a tree-like interface to view and manage your undo history,
-- making it easier to understand and utilize the undo functionality in Neovim.
later(function() vim.cmd.packadd('nvim.undotree') end)

later(function()
  add({
    'https://github.com/MagicDuck/grug-far.nvim',
  })

  require('grug-far').setup({})
end)
