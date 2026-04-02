--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  capabilities = capabilities,
  settings = {},
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript', 'typescriptreact', 'javascriptreact' },
  },
}
