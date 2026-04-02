local later = Config.later

-- Work with diff hunks that represent the difference between the buffer text and
-- some reference text set by a source. Default source uses text from Git index.
-- Also provides summary info used in developer section of 'mini.statusline'.
-- Example usage:
-- - `ghip` - apply hunks (`gh`) within *i*nside *p*aragraph
-- - `gHG` - reset hunks (`gH`) from cursor until end of buffer (`G`)
-- - `ghgh` - apply (`gh`) hunk at cursor (`gh`)
-- - `gHgh` - reset (`gH`) hunk at cursor (`gh`)
-- - `<Leader>go` - toggle overlay
--
-- See also:
-- - `:h MiniDiff-overview` - overview of how module works
-- - `:h MiniDiff-diff-summary` - available summary information
-- - `:h MiniDiff.gen_source` - available built-in sources
later(function()
  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = { add = '▎', change = '▎', delete = '▁' },
    },
    mappings = {
      -- Go to hunk range in corresponding direction
      goto_prev = '[c',
      goto_next = ']c',
    },
  })
end)

-- Git integration for more straightforward Git actions based on Neovim's state.
-- It is not meant as a fully featured Git client, only to provide helpers that
-- integrate better with Neovim. Example usage:
-- - `<Leader>gs` - show information at cursor
-- - `<Leader>gd` - show unstaged changes as a patch in separate tabpage
-- - `<Leader>gL` - show Git log of current file
-- - `:Git help git` - show output of `git help git` inside Neovim
--
-- See also:
-- - `:h MiniGit-examples` - examples of common setups
-- - `:h :Git` - more details about `:Git` user command
-- - `:h MiniGit.show_at_cursor()` - what information at cursor is shown
later(function() require('mini.git').setup() end)

-- Inline git blame virtual text and commit browsing.
-- <Leader>gb` — toggle inline git blame
-- `<Leader>gB` — open commit for current line in browser
later(function()
  local blame = require('git_blame')

  vim.keymap.set('n', '<leader>gb', blame.toggle, { desc = 'Toggle inline git blame' })
  vim.keymap.set('n', '<leader>gB', blame.browse, { desc = 'Open commit for current line in browser' })
end)
