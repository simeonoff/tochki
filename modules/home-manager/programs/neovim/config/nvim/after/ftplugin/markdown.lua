local map = vim.keymap.set
local opts = { expr = true, buffer = true, silent = true }

-- Enable spell checking for prose-heavy markdown buffers.
vim.opt_local.spell = true

-- Soft-wrap markdown lines to keep text readable in narrow windows.
vim.opt_local.wrap = true

-- Wrap on word boundaries instead of splitting words mid-line.
vim.opt_local.linebreak = true

-- Preserve indentation on wrapped lines for nested lists/quotes.
vim.opt_local.breakindent = true

-- Hard-wrap prose near 100 columns and keep a visual guide at the edge.
vim.opt_local.textwidth = 120
vim.opt_local.colorcolumn = '+1'

-- Use Vim's built-in `gq` for markdown reflow (respects `textwidth`).
vim.opt_local.formatexpr = ''

-- Prefer paragraph reflow behavior over comment-style auto prefixes.
vim.opt_local.formatoptions:append({ 't', 'n' })
vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })

-- Move by visual (wrapped) lines unless an explicit count is provided.
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", opts)
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", opts)

-- Mirror wrapped-line movement for arrow keys.
map('n', '<Down>', "v:count == 0 ? 'gj' : 'j'", opts)
map('n', '<Up>', "v:count == 0 ? 'gk' : 'k'", opts)
