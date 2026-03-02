local add = vim.pack.add
local later = Config.later

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
