local M = {}

local ns = vim.api.nvim_create_namespace('git_blame')
local enabled = false

vim.api.nvim_set_hl(0, 'GitBlameVirtText', { link = 'LineNr' })

--- Parse `git blame --porcelain` output into structured fields.
--- @param stdout string raw porcelain output
--- @return {sha: string, author: string, author_time: string}?
local function parse_porcelain(stdout)
  local info = {}

  for _, line in ipairs(vim.split(stdout, '\n', { trimempty = true })) do
    if not info.sha and line:match('^%x+ %d+ %d+') then
      info.sha = line:match('^(%x+)')
    elseif line:match('^author ') then
      info.author = line:sub(8)
    elseif line:match('^author%-time ') then
      info.author_time = line:sub(13)
    end
  end

  if not info.sha or info.sha:match('^0+$') then return nil end
  if not info.author or info.author == 'Not Committed Yet' then return nil end

  return info
end

--- Build the `git blame` command for a single line.
--- @param file string absolute file path
--- @param lnum integer 1-indexed line number
--- @return string[]
local function blame_cmd(file, lnum)
  return { 'git', 'blame', '-L', lnum .. ',' .. lnum, '--porcelain', '--', file }
end

--- Fetch blame for a single line and render it as virtual text.
--- @param win integer window handle to read cursor from
--- @param bufnr integer buffer handle to render into
local function render_blame(win, bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == '' or vim.bo[bufnr].buftype ~= '' then return end

  local lnum = vim.api.nvim_win_get_cursor(win)[1]

  local line_text = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
  if not line_text or line_text:match('^%s*$') then return end

  vim.system(
    blame_cmd(file, lnum),
    { text = true, cwd = vim.fs.dirname(file) },
    vim.schedule_wrap(function(obj)
      if obj.code ~= 0 or not obj.stdout or not enabled then return end
      if not vim.api.nvim_buf_is_valid(bufnr) then return end

      local ok, cursor = pcall(vim.api.nvim_win_get_cursor, win)
      if not ok or cursor[1] ~= lnum then return end

      local info = parse_porcelain(obj.stdout)
      if not info then return end

      local text = string.format(
        '  %s — %s, %s',
        info.sha:sub(1, 7),
        info.author,
        os.date('%Y-%m-%d', tonumber(info.author_time))
      )

      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, {
        virt_text = { { text, 'GitBlameVirtText' } },
        virt_text_pos = 'eol',
        hl_mode = 'combine',
      })
    end)
  )
end

--- Clear blame virtual text from a buffer.
--- @param bufnr integer
local function clear_blame(bufnr) vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1) end

--- Enable inline blame. Registers autocmds and renders immediately.
function M.enable()
  enabled = true
  local augroup = vim.api.nvim_create_augroup('git_blame', { clear = true })

  vim.api.nvim_create_autocmd('CursorHold', {
    group = augroup,
    callback = function(ev) render_blame(vim.api.nvim_get_current_win(), ev.buf) end,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
    group = augroup,
    callback = function(ev) clear_blame(ev.buf) end,
  })

  render_blame(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
end

--- Disable inline blame. Clears autocmds and all extmarks.
function M.disable()
  enabled = false
  vim.api.nvim_create_augroup('git_blame', { clear = true })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then clear_blame(bufnr) end
  end
end

--- Toggle inline blame on/off.
function M.toggle()
  if enabled then M.disable() else M.enable() end
end

--- @return boolean
function M.is_enabled() return enabled end

--- Open the commit for the current line in the browser.
--- Resolves the SHA via `git blame` and the remote URL via `git remote`.
function M.browse()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' or vim.bo.buftype ~= '' then
    vim.notify('GitBrowse: not a file buffer', vim.log.levels.WARN)
    return
  end

  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local cwd = vim.fs.dirname(file)

  local result = vim.system(blame_cmd(file, lnum), { text = true, cwd = cwd }):wait()
  if result.code ~= 0 or not result.stdout then
    vim.notify('GitBrowse: not in a git repository', vim.log.levels.WARN)
    return
  end

  local info = parse_porcelain(result.stdout)
  if not info then
    vim.notify('GitBrowse: line not committed yet', vim.log.levels.WARN)
    return
  end

  local remote = vim.system({ 'git', 'remote', 'get-url', 'origin' }, { text = true, cwd = cwd }):wait()
  if remote.code ~= 0 or not remote.stdout then
    vim.notify('GitBrowse: no remote origin found', vim.log.levels.WARN)
    return
  end

  -- Convert git remote URL to browser-friendly HTTPS URL.
  -- Handles: git@host:user/repo.git, ssh://git@host/user/repo.git,
  --          https://host/user/repo.git
  local remote_url = vim.trim(remote.stdout)
  remote_url = remote_url:gsub('%.git$', '')
  remote_url = remote_url:gsub('^git@([^:]+):', 'https://%1/')
  remote_url = remote_url:gsub('^ssh://git@', 'https://')

  local url = remote_url .. '/commit/' .. info.sha

  if vim.fn.has('mac') == 1 then
    vim.system({ 'open', url })
  elseif vim.fn.has('unix') == 1 then
    vim.system({ 'xdg-open', url })
  end
end

return M
