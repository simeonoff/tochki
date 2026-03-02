-- Custom fold text.

function _G.custom_foldtext()
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
