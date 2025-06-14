local utils = require('utils')
local bufonly = require('bufonly')
local lualine = require('lualine')
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group_id = augroup('rooter', { clear = true })
local personal_augroup = augroup('personal_augroup', { clear = true })
local view_group = augroup('auto_view', { clear = true })

vim.api.nvim_create_user_command('BufOnly', function() bufonly.BufOnly() end, {})

-- Pressing q closes the quickfix, help and other windows
autocmd({ 'FileType' }, {
  pattern = {
    'qf',
    'help',
    'man',
    'notify',
    'oil',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Change conceallevel for specific filetypes
autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'md', 'markdown' },
  callback = function() vim.wo.conceallevel = 0 end,
  group = personal_augroup,
})

-- Turn on spellcheck for markdown files
autocmd('FileType', {
  pattern = { 'markdown' },
  callback = function() vim.opt.spell = true end,
})

-- Clears 'root_dir' variable for buffers on open/reload
autocmd('BufRead', {
  group = group_id,
  callback = function() vim.api.nvim_buf_set_var(0, 'root_dir', nil) end,
})

-- Change the current working directory to the root dir of the buffer
autocmd('BufEnter', {
  group = group_id,
  nested = true,
  callback = function()
    local excluded_filetypes = {
      ['neo-tree'] = true,
      ['NvimTree'] = true, -- Example of adding another filetype
    }
    local ft = vim.bo.filetype

    if not excluded_filetypes[ft] then
      -- Proceed with setting root_dir and changing directory
      local root = vim.b.root_dir or utils.get_root()

      if not vim.b.root_dir then
        vim.b.root_dir = root
        vim.api.nvim_buf_set_var(0, 'root_dir', root)
      end
    end
  end,
})

autocmd('RecordingEnter', {
  callback = function()
    lualine.refresh({
      place = { 'statusline' },
    })
  end,
})

autocmd('RecordingLeave', {
  callback = function()
    -- This is going to seem really weird!
    -- Instead of just calling refresh we need to wait a moment because of the nature of
    -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
    -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
    -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
    -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        lualine.refresh({
          place = { 'statusline' },
        })
      end)
    )
  end,
})

-- Automatically jump to the last known cursor position
autocmd('BufRead', {
  callback = function(opts)
    autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- Changes the colorscheme at runtime to the given argument
vim.api.nvim_create_user_command('Theme', function(opts)
  local ui = require('config.ui')
  local colorscheme = opts.args
  dd(colorscheme)

  ui.colorscheme.value = colorscheme
end, { nargs = 1 })

-- Automatically save and load views for buffers
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
  terminal = true,
  vim = true,
}

-- Save view when leaving a buffer
vim.api.nvim_create_autocmd('BufWinLeave', {
  group = view_group,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == '' or IGNORE_FILETYPES[ft] then return end

    vim.cmd.mkview({ mods = { emsg_silent = true } })
  end,
})

-- Load view when entering a buffer
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = view_group,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == '' or IGNORE_FILETYPES[ft] then return end

    vim.cmd.loadview({ mods = { emsg_silent = true } })
  end,
})
