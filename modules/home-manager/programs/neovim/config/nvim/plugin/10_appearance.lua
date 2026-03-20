local add = vim.pack.add
local now = Config.now

-- Perceptual color adjustment using OKLCH color space.
-- Lightens dark colors and darkens light colors by `amount` (default 5).
-- Works correctly with both light and dark themes.
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
    'https://github.com/tinted-theming/tinted-nvim.git',
  })

  require('tinted-nvim').setup({
    default_scheme = 'base16-rose-pine',
    compile = true,
    capabilities = {
      truecolor = true,
      terminal_colors = true,
      undercurl = true,
    },

    ui = {
      transparent = false,
      dim_inactive = false,
    },
    -- Text attribute styles
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
    },

    highlights = {
      -- Built-in plugin integrations
      integrations = {
        telescope = true,
        blink = true,
        notify = true,
        dapui = true,
        lualine = true,
      },

      overrides = function(palette)
        local cl_bg = dynamic_shade(palette.base00, 5)
        -- Intermediate shade between base01 and base02 for telescope results panel
        local overlay_bg = dynamic_shade(palette.base01, 3)

        return {
          -- Line numbers
          LineNr = { fg = palette.base03 },

          -- Comment
          Comment = { fg = palette.base04, italic = true },
          TSComment = { link = 'Comment' },

          -- CursorLine: slightly off-background via perceptual shading
          CursorLine = { bg = cl_bg },
          CursorLineNr = { fg = palette.base04, bg = 'NONE' },
          CursorLineSign = { bg = 'NONE' },
          CursorLineFold = { bg = 'NONE' },
          ColorColumn = { bg = cl_bg },

          -- Folds
          Folded = { fg = palette.base04, bg = 'NONE' },
          FoldColumn = { fg = palette.base03 },

          -- Separators
          WinSeparator = { fg = palette.base02 },

          -- Signs and indent guides
          SignColumn = { fg = palette.base03 },
          MiniIndentscopeSymbol = { fg = palette.base03 },
          MiniDiffSignChange = { fg = palette.base0E },

          -- Inline hints and completion ghost text
          LspInlayHint = { fg = palette.base04, italic = true },
          ComplHint = { fg = dynamic_shade(palette.base03), italic = true },

          -- Floats
          FloatBorder = { fg = palette.base01, bg = palette.base01 },
          FloatTitle = { fg = palette.base09, bg = palette.base01 },
          NormalFloat = { bg = palette.base01 },

          -- Telescope: layered panel design
          -- Three tiers: base01 (prompt/preview) < overlay (results) < selection_bg (selection)
          -- Borders match their panel bg for a borderless look
          TelescopeBorder = { fg = overlay_bg, bg = overlay_bg },
          TelescopeNormal = { fg = palette.base04, bg = overlay_bg },
          TelescopeTitle = { fg = overlay_bg, bg = overlay_bg },
          TelescopeSelection = { fg = palette.base05, bg = palette.base02 },
          TelescopeSelectionCaret = { fg = palette.base08, bg = dynamic_shade(palette.base02, 3) },
          TelescopeMultiSelection = { fg = palette.base05, bg = palette.base03 },
          TelescopePromptNormal = { fg = palette.base05, bg = palette.base01 },
          TelescopePromptBorder = { fg = palette.base01, bg = palette.base01 },
          TelescopePromptTitle = { fg = palette.base09, bg = palette.base01 },
          TelescopePromptPrefix = { fg = palette.base04 },
          TelescopePreviewNormal = { fg = palette.base05, bg = palette.base01 },
          TelescopePreviewTitle = { fg = palette.base01, bg = palette.base01 },
          TelescopePreviewBorder = { fg = palette.base01, bg = palette.base01 },

          -- Blink completion menu
          BlinkCmpMenu = { fg = palette.base05, bg = palette.base01 },
          BlinkCmpMenuBorder = { fg = palette.base01, bg = palette.base01 },
          BlinkCmpMenuSelection = { fg = palette.base05, bg = palette.base02 },
          BlinkCmpLabel = { fg = palette.base04 },
          BlinkCmpLabelMatch = { fg = palette.base05, bold = true },
          BlinkCmpLabelDetail = { fg = palette.base03 },
          BlinkCmpLabelDescription = { fg = palette.base03 },
          BlinkCmpLabelDeprecated = { fg = palette.base03, strikethrough = true },
          BlinkCmpSource = { fg = palette.base03 },

          -- Blink per-kind icon colors
          -- base0D (blue)    = functions/methods/constructors
          -- base08 (red)     = variables/fields/properties/references
          -- base0A (yellow)  = classes/interfaces/structs/modules/types
          -- base0B (green)   = text/snippets/files/folders
          -- base09 (orange)  = constants/enums/values/units
          -- base0E (purple)  = keywords/operators/events (+ fallback)
          -- base0C (cyan)    = colors/enum members
          BlinkCmpKind = { fg = palette.base0E },
          BlinkCmpKindFunction = { fg = palette.base0D },
          BlinkCmpKindMethod = { fg = palette.base0D },
          BlinkCmpKindConstructor = { fg = palette.base0D },
          BlinkCmpKindVariable = { fg = palette.base08 },
          BlinkCmpKindField = { fg = palette.base08 },
          BlinkCmpKindProperty = { fg = palette.base08 },
          BlinkCmpKindReference = { fg = palette.base08 },
          BlinkCmpKindClass = { fg = palette.base0A },
          BlinkCmpKindInterface = { fg = palette.base0A },
          BlinkCmpKindStruct = { fg = palette.base0A },
          BlinkCmpKindModule = { fg = palette.base0A },
          BlinkCmpKindTypeParameter = { fg = palette.base0A },
          BlinkCmpKindText = { fg = palette.base0B },
          BlinkCmpKindSnippet = { fg = palette.base0B },
          BlinkCmpKindFile = { fg = palette.base0B },
          BlinkCmpKindFolder = { fg = palette.base0B },
          BlinkCmpKindConstant = { fg = palette.base09 },
          BlinkCmpKindEnum = { fg = palette.base09 },
          BlinkCmpKindValue = { fg = palette.base09 },
          BlinkCmpKindUnit = { fg = palette.base09 },
          BlinkCmpKindKeyword = { fg = palette.base0E },
          BlinkCmpKindOperator = { fg = palette.base0E },
          BlinkCmpKindEvent = { fg = palette.base0E },
          BlinkCmpKindEnumMember = { fg = palette.base0C },
          BlinkCmpKindColor = { fg = palette.base0C },

          -- Blink documentation / hover panel
          BlinkCmpDoc = { fg = palette.base05, bg = palette.base01 },
          BlinkCmpDocBorder = { fg = palette.base01, bg = palette.base01 },
          BlinkCmpDocSeparator = { fg = palette.base02, bg = palette.base01 },
          BlinkCmpDocCursorLine = { bg = palette.base02 },
          BlinkCmpScrollBarThumb = { bg = palette.base02 },
          BlinkCmpScrollBarGutter = { bg = palette.base01 },
          BlinkCmpGhostText = { fg = palette.base03 },

          -- Visual selection
          Visual = { bg = palette.base01 },

          -- Punctuation: base0F is too faint in many schemes
          Delimiter = { fg = palette.base04 },
          ['@punctuation.delimiter'] = { fg = palette.base04 },
          ['@punctuation.special'] = { fg = palette.base04 },

          -- Lualine: use purple (base0E) for normal mode instead of dull grey
          LualineNormalA = { fg = palette.base00, bg = palette.base0E, bold = true },
          LualineNormalB = { fg = palette.base05, bg = palette.base02 },

          -- Trouble
          TroubleNormal = { bg = palette.base00 },

          -- Flash
          FlashLabel = { bg = palette.base08, fg = palette.base00, bold = true, italic = true },
        }
      end,
    },

    -- Auto-switch from tinty
    selector = {
      enabled = true,
      mode = 'file',
      path = '~/.local/share/tinted-theming/tinty/current_scheme',
      watch = true, -- auto-reload on file change
    },
  })
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
      -- hex_color = hipatterns.gen_highlighter.hex_color(),
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
