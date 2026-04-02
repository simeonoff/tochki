-- ┌────────────────┐
-- │ Plugin manager │
-- └────────────────┘
--
-- This config uses `vim.pack` - built-in plugin manager. Its main entry
-- point is a `vim.pack.add()` function, which acts like a "smarter `:packadd`":
-- load plugin after making sure it is installed from source. The state of
-- installed plugins is recorded in the lockfile named 'nvim-pack-lock.json'.
-- Example usage:
-- - `vim.pack.add({ ... })` - use inside config to add one or more plugins.
-- - `:lua vim.pack.update()` - update all plugins; execute `:write` to confirm.
-- - `:lua vim.pack.del({ ... })` - delete specific plugins.
--
-- See also:
-- - `:h vim.pack-examples` - how to use it
-- - `:h vim.pack-lockfile` - lockfile info
-- - `:h vim.pack-events` - available events and plugin hooks examples
-- - `:h vim.pack.update()` - more details about confirmation step

-- Define config table to be able to pass data between scripts
-- It is a global variable which can be use both as `_G.Config` and `Config`
_G.Config = {}

-- 'mini.nvim' - all-in-one plugin powering most MiniMax features.
-- Load now to have 'mini.misc' available for custom loading helpers.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Loading helpers used to organize config into fail-safe parts. Example usage:
-- - `now` - execute immediately. Use for what must be executed during startup.
--   Like colorscheme, statusline, tabline, dashboard, etc.
-- - `later` - execute a bit later. Use for things not needed during startup.
-- - `now_if_args` - use only if needed during startup when Neovim is started
--   like `nvim -- path/to/file`, but otherwise delaying is fine.
-- - Others are better used only if the above is not enough for good performance.
--   Use only if you are comfortable with adding complexity to your config:
--   - `on_event` - execute once on a first matched event. Like "delay until
--     first Insert mode enter": `on_event('InsertEnter', function() ... end)`.
--   - `on_filetype` - execute once on a first matched filetype. Like "delay
--     until first Lua file": `on_filetype('lua', function() ... end)`.
--
-- See also:
-- - `:h MiniMisc.safely()`
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end

-- Autocommands are Neovim's way to define actions that are executed on events
-- (like creating a buffer, setting an option, etc.).
--
-- See also:
-- - `:h autocommand`
-- - `:h nvim_create_augroup()`
-- - `:h nvim_create_autocmd()`
local gr = vim.api.nvim_create_augroup('custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end


-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end

_G.custom_foldtext = function()
  local buf = vim.api.nvim_get_current_buf()
  local foldstart = vim.v.foldstart
  local line = vim.api.nvim_buf_get_lines(buf, foldstart - 1, foldstart, false)[1] or ''
  local count = vim.v.foldend - foldstart

  -- Build highlighted chunks using tree-sitter captures
  local result = {}
  local ok, parser = pcall(vim.treesitter.get_parser, buf)

  if ok and parser then
    -- Force parse to ensure captures are available
    parser:parse()
    local col = 0
    while col < #line do
      local captures = vim.treesitter.get_captures_at_pos(buf, foldstart - 1, col)
      local hl = nil
      if #captures > 0 then hl = '@' .. captures[#captures].capture .. '.' .. captures[#captures].lang end
      -- Find the extent of this highlight
      local start_col = col
      col = col + 1
      while col < #line do
        local next_captures = vim.treesitter.get_captures_at_pos(buf, foldstart - 1, col)
        local next_hl = nil
        if #next_captures > 0 then
          next_hl = '@' .. next_captures[#next_captures].capture .. '.' .. next_captures[#next_captures].lang
        end
        if next_hl ~= hl then break end
        col = col + 1
      end
      table.insert(result, { line:sub(start_col + 1, col), hl or 'Folded' })
    end
  else
    table.insert(result, { line, 'Folded' })
  end
  table.insert(result, { ' … ' .. count .. ' lines', 'Comment' })

  return result
end

_G.P = function(v)
  print(vim.inspect(v))
  return v
end

Config.now_if_args(function()
  -- Makes `:h MiniMisc.put()` and `:h MiniMisc.put_text()` public
  misc.setup()

  -- Change current working directory based on the current file path. It
  -- searches up the file tree until the first root marker ('.git' or 'Makefile')
  -- and sets their parent directory as a current directory.
  -- This is helpful when simultaneously dealing with files from several projects.
  MiniMisc.setup_auto_root({ '.git', 'Makefile', 'package.json', '.luarc.json' })
end)

-- Extra 'mini.nvim' functionality.
--
-- See also:
-- - `:h MiniExtra.pickers` - pickers. Most are mapped in `<Leader>f` group.
--   Calling `setup()` makes 'mini.pick' respect 'mini.extra' pickers.
-- - `:h MiniExtra.gen_ai_spec` - 'mini.ai' textobject specifications
-- - `:h MiniExtra.gen_highlighter` - 'mini.hipatterns' highlighters
Config.later(function() require('mini.extra').setup() end)
