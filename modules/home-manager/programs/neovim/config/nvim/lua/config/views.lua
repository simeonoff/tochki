-- Automatically save and load views for buffers
-- This must be loaded immediately (not via VeryLazy) to ensure views are saved on exit

local view_group = vim.api.nvim_create_augroup('auto_view', { clear = true })

local IGNORE_FILETYPES = {
  ['copilot-chat'] = true,
  ['lazy_backdrop'] = true,
  ['snacks_layout_box'] = true,
  ['snacks_picker_input'] = true,
  ['snacks_picker_list'] = true,
  ['snacks_picker_preview'] = true,
  ['snacks_win_backdrop'] = true,
  ['vim-messages'] = true,
  checkhealth = true,
  fugitive = true,
  git = true,
  gitcommit = true,
  help = true,
  lazy = true,
  lspinfo = true,
  mason = true,
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

-- Save view when leaving a buffer
-- Temporarily switch to manual foldmethod to persist fold state with expr folds
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = view_group,
  callback = function(ev)
    if should_ignore_view(ev.buf) then return end

    -- Save current foldmethod and switch to manual to preserve fold state
    local foldmethod = vim.wo.foldmethod
    if foldmethod == 'expr' then
      vim.wo.foldmethod = 'manual'
    end

    vim.cmd.mkview({ mods = { emsg_silent = true } })

    -- Restore foldmethod
    if foldmethod == 'expr' then
      vim.wo.foldmethod = 'expr'
    end
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
