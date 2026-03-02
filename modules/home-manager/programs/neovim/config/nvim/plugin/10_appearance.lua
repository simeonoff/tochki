local add = vim.pack.add
local now, autocmd = Config.now, Config.new_autocmd
local set_hl = function(group, colors) vim.api.nvim_set_hl(0, group, colors) end

local function dynamic_shade(hex, amount)
  local colors = require('mini.colors')
  local color = colors.convert(hex, 'oklch')
  local _amount = amount or 5

  if color.l > 50 then
    color.l = color.l - _amount
  else
    color.l = color.l + _amount
  end

  return colors.convert(color, 'hex')
end

now(function()
  add({
    'https://github.com/RRethy/base16-nvim.git',
  })

  -- Test comment
  local overwrite_hl_groups = function()
    local c = require('base16-colorscheme').colors
    local cl_bg = dynamic_shade(c.base00)

    set_hl('Keyword', { italic = true })
    set_hl('Comment', { fg = c.base04, italic = true })
    set_hl('TSComment', { link = 'Comment' })
    set_hl('WinSeparator', { fg = c.base03 })
    set_hl('CursorLine', { bg = cl_bg })
    set_hl('CursorLineNr', { bg = cl_bg })
    set_hl('CursorLineSign', { bg = cl_bg })
    set_hl('CursorLineFold', { bg = cl_bg })
    set_hl('ColorColumn', { bg = cl_bg })
    set_hl('Folded', { fg = c.base04, bg = 'NONE' })
    set_hl('FoldColumn', { fg = c.base03 })
    set_hl('MiniIndentscopeSymbol', { fg = c.base03 })

    set_hl('MiniDiffSignChange', { fg = c.base0E })
  end

  autocmd('ColorScheme', 'base16-*', overwrite_hl_groups)

  require('base16-colorscheme').with_config({
    telescope = true,
    dapui = true,
  })

  vim.cmd('colorscheme base16-catppuccin')
end)
