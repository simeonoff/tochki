-- Native comment continuation for block comments and plain // lines.
vim.bo.comments = ':///,://,b:/*,e:*/'
vim.bo.formatoptions = vim.bo.formatoptions .. 'ro'

-- commentstring for toggle plugins — updates dynamically as cursor moves.
local function update_commentstring()
  local node = vim.treesitter.get_node()

  if node and (node:type() == 'sassdoc_content' or node:type() == 'sassdoc_line') then
    vim.bo.commentstring = '/// %s'
  else
    vim.bo.commentstring = '// %s'
  end
end

vim.api.nvim_create_autocmd('CursorMoved', {
  buffer = 0,
  callback = update_commentstring,
})

-- Sassdoc comment continuation for o, O, and <CR>.
-- /// always starts at column 0; content indent is preserved from the current line.
local function sassdoc_open(below)
  local line = vim.api.nvim_get_current_line()

  if not line:match('^%s*///') then
    local key = below and 'o' or 'O'
    vim.api.nvim_feedkeys(key, 'n', false)
    return
  end

  local indent = line:match('^%s*///([ \t]*)') or ' '

  if indent == '' then indent = ' ' end

  local new_line = '///' .. indent
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local insert_row = below and row or row - 1

  vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, { new_line })
  vim.api.nvim_win_set_cursor(0, { insert_row + 1, #new_line })
  vim.api.nvim_feedkeys('a', 'n', false)
end

vim.keymap.set('n', 'o', function() sassdoc_open(true) end, { buffer = 0 })
vim.keymap.set('n', 'O', function() sassdoc_open(false) end, { buffer = 0 })

vim.keymap.set('i', '<CR>', function()
  local line = vim.api.nvim_get_current_line()

  if not line:match('^%s*///') then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
    return
  end

  local indent = line:match('^%s*///([ \t]*)') or ' '

  if indent == '' then indent = ' ' end

  local new_line = '///' .. indent
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Split the current line at cursor, trim trailing whitespace from top half.
  local cur = vim.api.nvim_get_current_line()
  local before = cur:sub(1, col):gsub('%s+$', '')
  local after = cur:sub(col + 1)

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { before, new_line .. after })
  vim.api.nvim_win_set_cursor(0, { row + 1, #new_line })
  vim.api.nvim_feedkeys('a', 'n', false)
end, { buffer = 0 })
