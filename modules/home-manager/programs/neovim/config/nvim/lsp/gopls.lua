---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  workspace_required = true,
  root_markers = { { 'go.work', 'go.mod' }, '.git' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
}
