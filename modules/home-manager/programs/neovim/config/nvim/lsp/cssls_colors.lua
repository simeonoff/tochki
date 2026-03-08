-- Color-only cssls instance for scss/sass buffers.
-- scss is excluded from the main cssls filetypes (see lsp/cssls.lua) so that
-- somesass_ls is the sole provider of completion, hover, definitions, etc.
-- This separate instance strips all capabilities except colorProvider so
-- document_color can query it without interfering with somesass_ls.
return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'scss', 'sass' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  init_options = { provideFormatter = false },
  on_init = function(client)
    local caps = client.server_capabilities
    for key in pairs(caps) do
      if key ~= 'colorProvider' and key ~= 'textDocumentSync' then
        caps[key] = nil
      end
    end
  end,
  settings = {
    scss = { validate = false, lint = { unknownAtRules = 'ignore' } },
  },
}
