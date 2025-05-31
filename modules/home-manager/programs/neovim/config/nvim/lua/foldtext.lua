-- Custom fold text.
-- https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/

local NODES_TO_HIGHLIGHT = {
  css = { 'type' },
  html = { 'tag' },
  js = { 'function' },
  lua = { 'function', 'string' },
  python = { 'function', 'function.method' },
  scss = { 'type' },
  typescript = { 'constructor', 'function', 'function.method' },
  typescriptreact = { 'function' },
}

-- Cache highlight groups by filetype and node name for better performance
local highlight_cache = {}

local function get_hl_group(name)
  local ft = vim.bo.filetype

  -- Create cache key
  local cache_key = ft .. '_' .. name

  -- Return cached result if available
  if highlight_cache[cache_key] then return highlight_cache[cache_key] end

  -- Get nodes to highlight for current filetype, or empty table if none
  local nodes_to_highlight = NODES_TO_HIGHLIGHT[ft]

  -- Determine highlight group
  local hl = (nodes_to_highlight and vim.tbl_contains(nodes_to_highlight, name)) and 'FoldedHeading' or 'Folded'

  -- Cache the result
  highlight_cache[cache_key] = hl

  return hl
end

function _G.custom_fold_text()
  local pos = vim.v.foldstart
  local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]

  -- Check if this is a #region fold
  if line:find('#region') then
    -- Extract region name
    local region_name = line:match('#region%s*(.-)%s*$') or 'Region'
    if region_name == '' then region_name = 'Region' end

    local line_count = vim.v.foldend - vim.v.foldstart + 1
    return string.format('󱃄 %s (%d lines)', region_name, line_count)
  end

  -- For non-region folds, use default foldtext
  return vim.fn.foldtext()
end
