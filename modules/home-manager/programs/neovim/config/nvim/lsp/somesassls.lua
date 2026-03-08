--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  name = 'somesass_ls',
  cmd = { 'some-sass-language-server', '--stdio' },
  filetypes = { 'scss', 'sass' },
  root_markers = { 'package.json', '.git', },
  single_file_support = true,
  on_init = function(client)
    -- cssls_colors handles document colors for scss/sass files
    client.server_capabilities.colorProvider = nil
  end,
  settings = {
    somesass = {
      suggestAllFromOpenDocument = true,
      css = {
        lint = {
          unknownAtRules = 'ignore',
        },
      },
      scss = {
        lint = {
          unknownAtRules = 'ignore',
        },
      },
    },
  },
  capabilities = capabilities,
}
