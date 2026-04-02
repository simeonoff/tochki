-- Automatically save and load views for buffers
-- This must be loaded immediately to ensure views are saved on exit
local view_group = vim.api.nvim_create_augroup('auto_view', { clear = true })
local now = Config.now

local IGNORE_FILETYPES = {
  checkhealth = true,
  git = true,
  gitcommit = true,
  help = true,
  lspinfo = true,
  minifiles = true,
  mininotify = true,
  oil = true,
  terminal = true,
  vim = true,
}

local IGNORE_PATHS = {
  '^/nix/store',
  '^/private/var/folders',
  '^/tmp',
  '^' .. vim.fn.expand('~') .. '/Projects/tmp',
}

local function should_ignore_view(buf)
  local ft = vim.bo[buf].filetype
  if ft == '' or IGNORE_FILETYPES[ft] then return true end

  local path = vim.api.nvim_buf_get_name(buf)
  for _, pattern in ipairs(IGNORE_PATHS) do
    if path:match(pattern) then return true end
  end

  return false
end

now(function()
  -- Save view when leaving a buffer (cursor position, curdir only — folds excluded)
  vim.api.nvim_create_autocmd('BufWinLeave', {
    group = view_group,
    callback = function(ev)
      if should_ignore_view(ev.buf) then return end
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end,
  })

  -- Load view when entering a buffer
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = view_group,
    callback = function(ev)
      if should_ignore_view(ev.buf) then return end
      vim.cmd.loadview({ mods = { emsg_silent = true } })
    end,
  })
end)
