-- ╭──────────────────────────────────────────────────────────╮
-- │ Leader Keys                                              │
-- ╰──────────────────────────────────────────────────────────╯

-- Set <Space> as the leader key for custom keybindings
vim.g.mapleader = ' '
-- Set <Space> as the local leader key (used for filetype-specific mappings)
vim.g.maplocalleader = ' '

-- ╭──────────────────────────────────────────────────────────╮
-- │ UI / Display                                             │
-- ╰──────────────────────────────────────────────────────────╯

-- Always display the sign column (prevents layout shift from diagnostics/git signs)
vim.opt.signcolumn = 'yes'
-- Hide the default ruler (line/column info) from the bottom-right of the screen
vim.opt.ruler = false
-- Use single-line box-drawing characters for floating window borders
vim.opt.winborder = 'single'
-- Show line numbers relative to the cursor (makes jump commands like 5j easier)
vim.opt.relativenumber = true
-- Show the absolute line number on the current line (combines with relativenumber)
vim.opt.number = true
-- Highlight the line the cursor is currently on
vim.opt.cursorline = true
-- Display a vertical guide line at column 120 (useful for enforcing line length limits)
vim.opt.colorcolumn = '120'
-- Define visible characters for tabs, trailing spaces, and spaces when :set list is on
vim.opt.listchars = 'tab:->,trail:·,space:·'
-- Enable the display of whitespace characters defined in listchars
vim.cmd('set list')
-- Use a space for fold fill and hide the ~ tilde on empty lines past end-of-buffer
vim.opt.fillchars:append({ fold = ' ', eob = ' ' })

-- ╭──────────────────────────────────────────────────────────╮
-- │ Command Line / Statusline                                │
-- ╰──────────────────────────────────────────────────────────╯

-- Hide the mode indicator (e.g. -- INSERT --) from the command line (usually shown in statusline instead)
vim.opt.showmode = false
-- Use a single global statusline at the bottom instead of one per window
vim.go.laststatus = 3
-- Hide the command line when not in use (reclaims a row of screen space)
vim.opt.cmdheight = 0
-- Suppress the intro splash screen on startup
vim.opt.shortmess:append({ I = true })

-- ╭──────────────────────────────────────────────────────────╮
-- │ Indentation / Tabs                                       │
-- ╰──────────────────────────────────────────────────────────╯

-- Number of spaces that a <Tab> character displays as
vim.opt.tabstop = 4
-- Number of spaces inserted per <Tab> keypress in insert mode
vim.opt.softtabstop = 4
-- Number of spaces used for each level of auto-indentation
vim.opt.shiftwidth = 4
-- Convert tabs to spaces when inserting
vim.opt.expandtab = true
-- Copy the indentation of the current line when starting a new one
vim.opt.autoindent = true

-- ╭──────────────────────────────────────────────────────────╮
-- │ Search                                                   │
-- ╰──────────────────────────────────────────────────────────╯

-- Don't keep previous search matches highlighted after searching
vim.opt.hlsearch = false
-- Show search matches incrementally as you type the pattern
vim.opt.incsearch = true
-- Ignore case in search patterns by default (overridden by smartcase when uppercase is used)
vim.opt.ignorecase = true
-- Make search case-sensitive when the pattern contains uppercase characters
vim.opt.smartcase = true

-- ╭──────────────────────────────────────────────────────────╮
-- │ Editing / Input                                          │
-- ╰──────────────────────────────────────────────────────────╯

-- Allow backspace to delete over line breaks, auto-indentation, and the start of insert
vim.opt.backspace = { 'start', 'eol', 'indent' }
-- Enable mouse support in all modes (normal, insert, visual, command)
-- vim.opt.mouse = 'a'
-- Use the system clipboard for all yank, delete, change, and put operations
vim.opt.clipboard = 'unnamedplus'

-- ╭──────────────────────────────────────────────────────────╮
-- │ Completion / Popups                                      │
-- ╰──────────────────────────────────────────────────────────╯

-- Show the completion popup menu, even for a single match, without auto-selecting an entry
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- Disable transparency blending for popup menus (fully opaque)
vim.opt.pumblend = 0
-- Limit the completion popup menu to 10 visible entries
vim.opt.pumheight = 10

-- ╭──────────────────────────────────────────────────────────╮
-- │ Windows / Splits                                         │
-- ╰──────────────────────────────────────────────────────────╯

-- Open horizontal splits below the current window
vim.opt.splitbelow = true
-- Open vertical splits to the right of the current window
vim.opt.splitright = true

-- ╭──────────────────────────────────────────────────────────╮
-- │ Scrolling                                                │
-- ╰──────────────────────────────────────────────────────────╯

-- Keep at least 8 lines visible above/below the cursor when scrolling
vim.opt.scrolloff = 8

-- ╭──────────────────────────────────────────────────────────╮
-- │ Folding                                                  │
-- ╰──────────────────────────────────────────────────────────╯

-- Enable code folding
vim.opt.foldenable = true
-- Hide the fold column indicator in the gutter (folds shown via statuscolumn instead)
vim.opt.foldcolumn = '0'
-- Default fold level; 999 means all folds are open initially
vim.opt.foldlevel = 999
-- Fold level when opening a new buffer; 99 keeps most folds open
vim.opt.foldlevelstart = 99
-- Use an expression to determine fold boundaries
vim.opt.foldmethod = 'expr'
-- Automatically open folds when the cursor enters them via these actions
vim.opt.foldopen = 'insert,mark,search,tag,percent,quickfix'
-- Use Treesitter syntax tree to compute fold regions
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- Use a custom Lua function to render the text displayed for closed folds
vim.opt.foldtext = 'v:lua.custom_foldtext()'

-- Custom status column: sign column + fold indicators (+/-/│) + right-aligned line number
vim.opt.statuscolumn =
  '%s%#FoldColumn#%{foldlevel(v:lnum) > 0 ? (foldclosed(v:lnum) >= 0 ? " + " : (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? " - " : " │ ")) : "   "}%*%=%l '

-- ╭──────────────────────────────────────────────────────────╮
-- │ Spell Checking                                           │
-- ╰──────────────────────────────────────────────────────────╯

-- Set the spell-check language to US English
vim.opt.spelllang = { 'en_us' }
-- Disable spell checking by default (can be toggled on per-buffer)
vim.opt.spell = false
-- Show up to 8 spell suggestions, ranked by best match
vim.opt.spellsuggest = 'best,8'
-- Path to the custom spell file for user-added words
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'

-- ╭──────────────────────────────────────────────────────────╮
-- │ Backup / Undo / Sessions                                 │
-- ╰──────────────────────────────────────────────────────────╯

-- Persist undo history to disk so changes survive between sessions
vim.opt.undofile = true
-- Store up to 10,000 undo levels per buffer
vim.opt.undolevels = 10000
-- Enable backup files before overwriting
vim.opt.backup = true
-- Store backup files in the Neovim state directory (keeps project dirs clean)
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup'
-- Disable swap files globally (rely on undo history and backups instead)
vim.opt.swapfile = false
-- Save cursor position and current directory when using :mkview
vim.opt.viewoptions = { 'cursor', 'curdir' }
-- Items to save/restore with :mksession (folds, buffers, directory, tabs, window sizes)
vim.opt.sessionoptions = { 'folds', 'buffers', 'curdir', 'tabpages', 'winsize' }

-- ╭──────────────────────────────────────────────────────────╮
-- │ File / Path Filtering                                    │
-- ╰──────────────────────────────────────────────────────────╯

-- Exclude node_modules from file/path wildcard expansion and completion
vim.opt.wildignore = '*/node_modules/**/*'

-- ╭──────────────────────────────────────────────────────────╮
-- │ Performance                                              │
-- ╰──────────────────────────────────────────────────────────╯

-- Reduce the delay before CursorHold events fire (improves responsiveness of hover/diagnostics)
vim.opt.updatetime = 250
-- Automatically re-read files when they are changed outside of Neovim
vim.opt.autoread = true

-- ╭──────────────────────────────────────────────────────────╮
-- │ Disabled Built-in Plugins                                │
-- ╰──────────────────────────────────────────────────────────╯

-- Disable the built-in netrw file explorer (typically replaced by a plugin like nvim-tree or oil)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
