local M = {}

M.icons = {
  Namespace = '  ',
  Text = '  ',
  Method = '󰡱  ',
  Function = '󰡱 ',
  Constructor = '  ',
  Field = '  ',
  Variable = '  ',
  Class = '  ',
  Interface = '  ',
  Module = ' ',
  Property = '  ',
  Unit = '  ',
  Value = '  ',
  Enum = '  ',
  Keyword = '  ',
  Key = ' ',
  Snippet = ' ',
  Color = '  ',
  File = '  ',
  Reference = ' ',
  Folder = '  ',
  EnumMember = ' ',
  Constant = '  ',
  Struct = '  ',
  Event = '  ',
  Operator = '  ',
  TypeParameter = '  ',
  Table = ' ',
  Object = ' ',
  Tag = ' ',
  Array = '[]',
  Boolean = ' ',
  Number = ' ',
  Null = '  ',
  String = '  ',
  Calendar = ' ',
  Watch = '  ',
  Package = ' ',
  Copilot = ' ',
  Suggestion = ' ',
  Codeium = '󰘦 ',
}

M.get_icon = function(kind) return M.icons[kind] end

M.diagnostic_signs = {
  error = '󰅚 ',
  warn = '󰗖 ',
  hint = '󱇮 ',
  info = '󰰅 ',
}

M.diff_icons = {
  added = '󰐙 ',
  modified = '󰻃 ',
  removed = '󰍷 ',
}

return M
