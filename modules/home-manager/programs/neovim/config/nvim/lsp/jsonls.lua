local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = (function()
        local ok, store = pcall(require, 'schemastore')
        if ok then return store.json.schemas() end
        return {}
      end)(),
      validate = { enable = true },
    },
  },
  root_markers = { '.git' },
  capabilities = capabilities,
  single_file_support = true,
}
