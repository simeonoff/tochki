local utils = require('utils')
local map = vim.keymap.set
local later = Config.later

map('n', '-', function() require('oil').open() end, { desc = 'Open parent directory' })

-- Seamlessly navigate between Neovim windows and tmux panes
map('n', '<C-Right>', function() utils.navigate('l') end, { noremap = true, silent = true })
map('n', '<C-Left>', function() utils.navigate('h') end, { noremap = true, silent = true })
map('n', '<C-Up>', function() utils.navigate('k') end, { noremap = true, silent = true })
map('n', '<C-Down>', function() utils.navigate('j') end, { noremap = true, silent = true })

-- Conform keybindings
later(function()
  map('', '<leader>i', function() vim.cmd('Format') end, { desc = 'Format buffer' })
end)

-- Flash keybindings
later(function()
  map({ 'n', 'x', 'o' }, 's', function() require('flash').jump({ continue = false }) end, { desc = 'Flash' })
  map({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
  map({ 'c' }, '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
end)

-- Tree-sitter textobjects keybindings
later(function()
  local select = require('nvim-treesitter-textobjects.select')

  map(
    { 'x', 'o' },
    'af',
    function() select.select_textobject('@function.outer', 'textobjects') end,
    { desc = 'Select the outer part of a function/method' }
  )

  map(
    { 'x', 'o' },
    'if',
    function() select.select_textobject('@function.inner', 'textobjects') end,
    { desc = 'Select the inner part of a function/method' }
  )

  -- TODO: Just a reminder to include the remaining tree-sitter textobject keybindings
  --       keymaps = {
  --         ['ab'] = { query = '@block.outer', desc = 'Select the outer part of a code block' },
  --         ['ib'] = { query = '@block.inner', desc = 'Select the inner part of a code block' },
  --         ['ac'] = { query = '@call.outer', desc = 'Select the outer part of a cal' },
  --         ['ic'] = { query = '@call.inner', desc = 'Select the inner part of a call' },
  --         ['a='] = { query = '@assignment.outer', desc = 'Select the outer part of an assignment' },
  --         ['i='] = { query = '@assignment.inner', desc = 'Select the inner part of an assignment' },
  --         -- ["l="] = { query = "@assignment.lhs", desc = "Select the lhs of an assignment" },
  --         -- ["r="] = { query = "@assignment.rhs", desc = "Select the lhs of an assignment" },
  --       },
  --     },
end)

-- from Primeagen
map('n', 'n', 'nzzzv', { desc = 'Center the view when going over next match' })
map('n', 'N', 'Nzzzv', { desc = 'Center the view when going over previous match' })

map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move visual selection up' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move visual selection down' })
map('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })
map('n', 'Q', '<nop>', { desc = 'Disable Ex mode' })

-- greatest remap
map('x', '<leader>p', [["_dP]], { desc = "Replace highlighted text from what's in the void registry" })

-- rename the word under the cursor
map({ 'n', 'x' }, '<leader>s', utils.rename_cword, { desc = 'Rename the word under the cursor' })

-- Open the URI under the cursor
map('n', '<leader>gx', utils.open_location, { silent = true, desc = 'Open the file/url under the cursor' })

map('n', '<leader>gs', function() vim.cmd('Git status') end, { desc = 'Toggle git status view' })

map('n', '<leader>gc', function() vim.cmd('tab Git commits') end, { silent = true, desc = 'Open git commits' })

-- LSP
map('n', 'gd', function() vim.lsp.buf.definition() end)
map('n', 'gi', function() vim.lsp.buf.implementation() end)
map('n', 'K', function() vim.lsp.buf.hover() end)
map('n', 'gK', function() vim.lsp.buf.signature_help() end)
map('n', '<leader>vd', function() vim.diagnostic.open_float() end)
map('n', '<leader>ca', function() vim.lsp.buf.code_action({ apply = true }) end)
map('n', '<leader>vrn', function() vim.lsp.buf.rename() end)

-- LSP inline completion
map('i', '<C-y>', function()
  if not vim.lsp.inline_completion.get() then return '<C-y>' end
end, { expr = true })
map('i', '<M-]>', vim.lsp.inline_completion.select)
map('i', '<M-[>', function() vim.lsp.inline_completion.select({ count = -1 }) end)
