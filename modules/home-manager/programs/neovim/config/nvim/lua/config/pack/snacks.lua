local banners = require('banners')

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    -- Patch the dashboard startup section to use our loader stats
    local dashboard = require('snacks.dashboard')
    dashboard.sections.startup = function()
      local stats = require('config.loader').stats()
      return {
        align = 'center',
        text = {
          { '⚡ Neovim loaded ', hl = 'footer' },
          { stats.loaded .. '/' .. stats.total, hl = 'special' },
          { ' plugins in ', hl = 'footer' },
          { stats.time_ms .. 'ms', hl = 'special' },
        },
      }
    end

    require('snacks').setup(opts)
  end,
  opts = {
    bigfile = { enabled = false },
    dashboard = {
      enabled = true,
      preset = {
        pick = nil,
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ':FindFiles' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ':FindText' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ':RecentFiles' },
          { icon = ' ', key = 'c', desc = 'Config', action = ':ConfigFiles' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        header = banners['shinobi'],
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    explorer = { enabled = false },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
      scope = {
        enabled = false,
      },
    },
    input = { enabled = true },
    picker = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    zen = { enabled = true },
  },
  keys = {
    {
      '<leader>bd',
      function() Snacks.bufdelete() end,
      mode = 'n',
      desc = 'Delete the current buffer',
    },
    {
      '<leader>bo',
      function() Snacks.bufdelete.other() end,
      mode = 'n',
      desc = 'Deletes all buffers except the current one',
    },
  },
  init = function()
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function() Snacks.debug.backtrace() end
    vim.print = _G.dd

    -- Rename files
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OilActionsPost',
      callback = function(event)
        if event.data.actions.type == 'move' then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
  end,
}
