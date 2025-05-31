-- Custom fold expression that extends treesitter folding with #region support
local function custom_fold_expr()
  local line = vim.fn.getline(vim.v.lnum)

  -- Handle #region comments first
  if line:find('#region') then
    return '>1' -- Start fold at level 1
  elseif line:find('#endregion') then
    return '<1' -- End fold at level 1
  end

  -- Get treesitter fold level
  local ts_fold = vim.treesitter.foldexpr()

  -- For region content, maintain fold level
  if ts_fold == '0' or ts_fold == '=' then
    -- Check if we're inside a region by looking for previous #region
    local current_line = vim.v.lnum

    for i = current_line - 1, 1, -1 do
      local prev_line = vim.fn.getline(i)

      if prev_line:find('#endregion') then
        break -- Found endregion before region, not in a region
      elseif prev_line:find('#region') then
        return '1' -- We're inside a region, maintain fold level 1
      end
    end
  end

  -- If treesitter has a fold, use it; otherwise return '='
  return ts_fold ~= '0' and ts_fold or '='
end

_G.custom_fold_expr = custom_fold_expr
