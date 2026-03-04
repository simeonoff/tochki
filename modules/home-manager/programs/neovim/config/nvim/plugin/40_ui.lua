local add = vim.pack.add
local now, autocmd = Config.now, Config.new_autocmd

-- Lualine setup
now(function()
  add({
    'https://github.com/nvim-lualine/lualine.nvim',
  })

  local lualine = require('lualine')
  local diagnostic_signs = require('kind').diagnostic_signs
  local diff_signs = require('kind').diff_icons

  local get_hex = require('utils').get_hl

  local normal_bg = get_hex('Normal', 'bg')
  local success_fg = get_hex('DiagnosticOk', 'fg')
  local error_fg = get_hex('DiagnosticError', 'fg')

  local window_width_limit = 100
  local branch_icon = '󰘬 '
  local gstatus = { ahead = 0, behind = 0 }

  local disabled_filetypes = {
    TelescopePrompt = true,
    lazy = true,
    oil = true,
    lazygit = true,
    Trouble = true,
    trouble = true,
    lspinfo = true,
    snacks_dashboard = true,
  }

  local lsp_kind = {
    tsserver = 'TSServer',
    eslint = 'ESLint',
    angularls = 'Angular LS',
    cssls = 'CSS LS',
    emmet_ls = 'Emmet',
    html = 'HTML',
    jsonls = 'JSON',
    lua_ls = 'Lua LS',
    marksman = 'Marksman',
    stylelint_lsp = 'Stylelint',
    svelte = 'Svelte',
    bashls = 'Bash',
  }

  autocmd('RecordingEnter', nil, function()
    lualine.refresh({
      place = { 'statusline' },
    })
  end)

  autocmd('RecordingLeave', nil, function()
    -- This is going to seem really weird!
    -- Instead of just calling refresh we need to wait a moment because of the nature of
    -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
    -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
    -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
    -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
    local timer = vim.uv.new_timer()

    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        lualine.refresh({
          place = { 'statusline' },
        })
      end)
    )
  end)

  -- Get info from git about ahead/behind commits in branch
  local function update_gstatus()
    vim.system({ 'git', 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' }, { text = true }, function(obj)
      if obj.code ~= 0 then
        gstatus = { ahead = 0, behind = 0 }
        return
      end

      local ahead, behind = (obj.stdout or ''):match('(%d+)%s*(%d+)')
      gstatus = { ahead = tonumber(ahead) or 0, behind = tonumber(behind) or 0 }
    end)
  end

  -- Start a timer to check for git status updates
  if _G.Gstatus_timer == nil then
    _G.Gstatus_timer = vim.uv.new_timer()
  else
    _G.Gstatus_timer:stop()
  end
  _G.Gstatus_timer:start(0, 2000, vim.schedule_wrap(update_gstatus))

  local function show_macro_recording()
    local base = ''
    local recording_register = vim.fn.reg_recording()
    if recording_register == base then
      return base
    else
      return 'Recording @' .. recording_register
    end
  end

  local conditions = {
    buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
    hide_in_width = function() return vim.o.columns > window_width_limit end,
    hide_in_disabled_ft = function()
      local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
      return not disabled_filetypes[buf_ft]
    end,
  }

  local function diff_source()
    local s = vim.b.minidiff_summary

    if s then return {
      added = s.add,
      modified = s.change,
      removed = s.delete,
    } end
  end

  local mode = {
    'mode',
    separator = { right = '', left = '' },
  }

  local branch = {
    'b:minigit_summary_string',
    icon = branch_icon,
    separator = { right = '', left = '' },
  }

  local status = {
    function() return ' ' .. gstatus.behind .. '  ' .. gstatus.ahead end,
    cond = function() return vim.b.minigit_summary and (gstatus.behind > 0 or gstatus.ahead > 0) end,
    padding = { left = 0, right = 1 },
    separator = { right = '', left = '' },
  }

  local diff = {
    'diff',
    source = diff_source,
    symbols = {
      added = diff_signs.added,
      modified = diff_signs.modified,
      removed = diff_signs.removed,
    },
    padding = { left = 2, right = 1 },
    cond = nil,
  }

  local diagnostics = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = {
      error = diagnostic_signs.error .. ' ',
      warn = diagnostic_signs.warn .. ' ',
      info = diagnostic_signs.info .. ' ',
      hint = diagnostic_signs.hint .. ' ',
    },
  }

  local treesitter = {
    function() return ' ' end,
    padding = { left = 1, right = 1 },
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and success_fg or error_fg }
    end,
    cond = conditions.hide_in_disabled_ft,
  }

  local location = {
    'location',
  }

  local spaces = {
    function()
      local shiftwidth = vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
      return 'Spaces: ' .. shiftwidth
    end,
  }

  local encoding = {
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
  }

  local filetype = {
    'filetype',
    icon_only = true,
    separator = { right = '', left = '' },
    padding = { left = 1, right = 0 },
    cond = conditions.hide_in_disabled_ft,
  }

  local filename = {
    'filename',
    padding = { left = 1, right = 0 },
    file_status = true, -- displays file status (readonly status, modified status)
    newfile_status = false,
    path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
    symbols = {
      modified = '●',
      readonly = '',
      unnamed = '',
    },
    separator = { right = '', left = '' },
    cond = conditions.hide_in_disabled_ft,
  }

  local lsp = {
    function() return ' ' end,
    on_click = function() vim.cmd('checkhealth lsp') end,
    padding = { left = 1, right = 2 },
    color = function()
      local clients = vim.lsp.get_clients()
      local c = {}

      for _, client in pairs(clients) do
        table.insert(c, lsp_kind[client.name] or client.name)
      end

      return { fg = #c > 0 and success_fg or error_fg }
    end,
    cond = conditions.hide_in_disabled_ft,
  }

  -- local plugins = {
  --   function() return '󰦗  Updates' end,
  --   cond = function() return #plugin_checker.updated > 0 end,
  --   on_click = function() vim.cmd('Lazy') end,
  --   color = {
  --     fg = palette.rose,
  --     bg = palette.highlight_med,
  --   },
  --   padding = { left = 1, right = 0 },
  --   separator = { right = '', left = '' },
  -- }

  local macros = {
    'macro-recording',
    fmt = show_macro_recording,
    color = {
      fg = normal_bg,
      bg = error_fg,
    },
    separator = { right = '', left = '' },
  }

  lualine.setup({
    options = {
      theme = 'tinted',
      icons_enabled = true,
      component_separators = '',
      section_separators = { left = '', right = '' },
      ignore_focus = {},
    },
    sections = {
      lualine_a = {
        mode,
        -- plugins,
      },
      lualine_b = {
        filetype,
        filename,
      },
      lualine_c = {},
      lualine_x = {
        macros,
        location,
        spaces,
        encoding,
        diagnostics,
        treesitter,
        lsp,
      },
      lualine_y = {},
      lualine_z = {
        status,
        branch,
      },
    },
    inactive_sections = {
      lualine_a = {
        mode,
        -- plugins,
      },
      lualine_b = {
        filetype,
        filename,
      },
      lualine_c = {},
      lualine_x = {
        spaces,
        encoding,
      },
      lualine_y = {},
      lualine_z = {
        status,
        branch,
      },
    },
    winbar = {},
    tabline = {},
    extensions = {
      'man',
      'trouble',
      'nvim-dap-ui',
      'quickfix',
      'oil',
    },
  })
end)

-- Notifications provider. Shows all kinds of notifications in the upper right
-- corner (by default). Example usage:
-- - `:h vim.notify()` - show notification (hides automatically)
-- - `<Leader>en` - show notification history
--
-- See also:
-- - `:h MiniNotify.config` for some of common configuration examples.
now(function() require('mini.notify').setup() end)
