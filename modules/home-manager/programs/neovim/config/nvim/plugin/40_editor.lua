local add = vim.pack.add
local later, autocmd = Config.later, Config.new_autocmd
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

  -- Register linters
  lint.linters_by_ft = {
    go = {},
    lua = {},
  }

  -- Listen for file writes and lint
  vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
    callback = function() lint.try_lint() end,
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
-- - Autocorrection of words as-you-type. Like `:W`->`:w`, `:lau`->`:lua`, etc.
-- - Autopeek command range (like line number at the start) as-you-type.
later(function() require('mini.cmdline').setup() end)

-- Pressing q closes the quickfix, help and other windows
later(function()
  autocmd('FileType', {
    'qf',
    'help',
    'man',
    'notify',
    'oil',
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
