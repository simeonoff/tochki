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

  local overwrite_hl_groups = function()
    local c = require('base16-colorscheme').colors
    local cl_bg = dynamic_shade(c.base00)

    -- Intermediate shade between base01 and base02 for the "overlay" tier
    -- (results panel background, sitting between prompt/preview and selection)
    local overlay_bg = dynamic_shade(c.base01, 3)

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

    -- Telescope: layered panel design
    -- Three background tiers: base01 (prompt/preview) < overlay_bg (results) < base02 (selection)
    -- Borders match their panel bg to create a "borderless" look
    --
    -- Results panel (main body)
    set_hl('TelescopeBorder', { fg = overlay_bg, bg = overlay_bg })
    set_hl('TelescopeNormal', { fg = c.base04, bg = overlay_bg })
    set_hl('TelescopeTitle', { fg = overlay_bg, bg = overlay_bg })

    -- Selection
    set_hl('TelescopeSelection', { fg = c.base05, bg = c.base02 })
    set_hl('TelescopeSelectionCaret', { fg = c.base08, bg = c.base02 })
    set_hl('TelescopeMultiSelection', { fg = c.base05, bg = c.base03 })

    -- Prompt area (input field)
    set_hl('TelescopePromptNormal', { fg = c.base05, bg = c.base01 })
    set_hl('TelescopePromptBorder', { fg = c.base01, bg = c.base01 })
    set_hl('TelescopePromptTitle', { fg = c.base09, bg = c.base01 })

    -- Preview area
    set_hl('TelescopePreviewNormal', { fg = c.base05, bg = c.base01 })
    set_hl('TelescopePreviewTitle', { fg = c.base01, bg = c.base01 })
    set_hl('TelescopePreviewBorder', { fg = c.base01, bg = c.base01 })

    -- Floats (LSP hover, diagnostics, etc.)
    set_hl('FloatBorder', { fg = c.base01, bg = c.base01 })
    set_hl('FloatTitle', { fg = c.base09, bg = c.base01 })
    set_hl('NormalFloat', { bg = c.base01 })

    -- Blink completion menu: same surface tier as floats (base01)
    -- with borders blending into the background for a clean look
    set_hl('BlinkCmpMenu', { fg = c.base05, bg = c.base01 })
    set_hl('BlinkCmpMenuBorder', { fg = c.base01, bg = c.base01 })
    set_hl('BlinkCmpMenuSelection', { fg = c.base05, bg = c.base02 })

    set_hl('BlinkCmpLabel', { fg = c.base04 })
    set_hl('BlinkCmpLabelMatch', { fg = c.base05, bold = true })
    set_hl('BlinkCmpLabelDetail', { fg = c.base03 })
    set_hl('BlinkCmpLabelDescription', { fg = c.base03 })
    set_hl('BlinkCmpLabelDeprecated', { fg = c.base03, strikethrough = true })

    set_hl('BlinkCmpKind', { fg = c.base0E })
    set_hl('BlinkCmpSource', { fg = c.base03 })

    -- Per-kind icon colors following base16 syntax semantics:
    -- base0D (blue)    = functions/methods/constructors
    -- base08 (red)     = variables/fields/properties/references
    -- base0A (yellow)  = classes/interfaces/structs/modules/types
    -- base0B (green)   = strings/text/snippets/files/folders
    -- base09 (orange)  = constants/enums/values/units/booleans
    -- base0E (purple)  = keywords/operators/events
    -- base0C (cyan)    = colors/enum members/type parameters
    set_hl('BlinkCmpKindFunction', { fg = c.base0D })
    set_hl('BlinkCmpKindMethod', { fg = c.base0D })
    set_hl('BlinkCmpKindConstructor', { fg = c.base0D })

    set_hl('BlinkCmpKindVariable', { fg = c.base08 })
    set_hl('BlinkCmpKindField', { fg = c.base08 })
    set_hl('BlinkCmpKindProperty', { fg = c.base08 })
    set_hl('BlinkCmpKindReference', { fg = c.base08 })

    set_hl('BlinkCmpKindClass', { fg = c.base0A })
    set_hl('BlinkCmpKindInterface', { fg = c.base0A })
    set_hl('BlinkCmpKindStruct', { fg = c.base0A })
    set_hl('BlinkCmpKindModule', { fg = c.base0A })
    set_hl('BlinkCmpKindTypeParameter', { fg = c.base0A })

    set_hl('BlinkCmpKindText', { fg = c.base0B })
    set_hl('BlinkCmpKindSnippet', { fg = c.base0B })
    set_hl('BlinkCmpKindFile', { fg = c.base0B })
    set_hl('BlinkCmpKindFolder', { fg = c.base0B })

    set_hl('BlinkCmpKindConstant', { fg = c.base09 })
    set_hl('BlinkCmpKindEnum', { fg = c.base09 })
    set_hl('BlinkCmpKindEnumMember', { fg = c.base0C })
    set_hl('BlinkCmpKindValue', { fg = c.base09 })
    set_hl('BlinkCmpKindUnit', { fg = c.base09 })

    set_hl('BlinkCmpKindKeyword', { fg = c.base0E })
    set_hl('BlinkCmpKindOperator', { fg = c.base0E })
    set_hl('BlinkCmpKindEvent', { fg = c.base0E })

    set_hl('BlinkCmpKindColor', { fg = c.base0C })

    -- Blink documentation / hover panel
    set_hl('BlinkCmpDoc', { fg = c.base05, bg = c.base01 })
    set_hl('BlinkCmpDocBorder', { fg = c.base01, bg = c.base01 })
    set_hl('BlinkCmpDocSeparator', { fg = c.base02, bg = c.base01 })
    set_hl('BlinkCmpDocCursorLine', { bg = c.base02 })

    set_hl('BlinkCmpScrollBarThumb', { bg = c.base02 })
    set_hl('BlinkCmpScrollBarGutter', { bg = c.base01 })

    set_hl('BlinkCmpGhostText', { fg = c.base03 })

    -- Trouble
    set_hl('TroubleNormal', { bg = c.base00 })
  end

  autocmd('ColorScheme', 'base16-*', overwrite_hl_groups)

  require('base16-colorscheme').with_config({
    telescope = false,
    dapui = true,
  })

  vim.cmd('colorscheme base16-rose-pine')
end)

now(function()
  add({
    'https://github.com/nvim-tree/nvim-web-devicons.git',
  })

  require('nvim-web-devicons').setup()
end)

now(function()
  local hipatterns = require('mini.hipatterns')

  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  local function jump_todo(direction)
    local hi = require('mini.hipatterns')
    local matches = hi.get_matches(0, { 'todo', 'fixme', 'hack', 'note' })

    if #matches == 0 then return end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local cur_line, cur_col = cursor[1], cursor[2] + 1

    if direction == 'next' then
      for _, m in ipairs(matches) do
        if m.lnum > cur_line or (m.lnum == cur_line and m.col > cur_col) then
          vim.api.nvim_win_set_cursor(0, { m.lnum, m.col - 1 })
          return
        end
      end
      -- Wrap: jump to first match
      vim.api.nvim_win_set_cursor(0, { matches[1].lnum, matches[1].col - 1 })
    else
      for i = #matches, 1, -1 do
        local m = matches[i]
        if m.lnum < cur_line or (m.lnum == cur_line and m.col < cur_col) then
          vim.api.nvim_win_set_cursor(0, { m.lnum, m.col - 1 })
          return
        end
      end
      -- Wrap: jump to last match
      local last = matches[#matches]
      vim.api.nvim_win_set_cursor(0, { last.lnum, last.col - 1 })
    end
  end

  vim.keymap.set('n', ']t', function() jump_todo('next') end, { desc = 'Next TODO' })
  vim.keymap.set('n', '[t', function() jump_todo('prev') end, { desc = 'Prev TODO' })
end)
