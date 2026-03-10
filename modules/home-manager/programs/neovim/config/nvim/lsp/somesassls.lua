--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  name = 'somesass_ls',
  cmd = { 'some-sass-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'sass' },
  root_markers = { 'package.json', '.git' },
  single_file_support = true,
  on_init = function(client)
    -- cssls_colors handles document colors for scss/sass files
    client.server_capabilities.colorProvider = nil
  end,
  settings = {
    somesass = {
      scss = {
        codeActions = {
          enabled = true,
        },
        colors = {
          enabled = true,
          includeFromCurrentDocument = true,
        },
        completion = {
          enabled = true,
          css = true,
          includeFromCurrentDocument = true,
        },
        definitions = {
          enabled = true,
        },
        diagnostics = {
          enabled = true,
          lint = {
            enabled = true,
            unknownAtRules = 'ignore',
          },
        },
        documentSymbols = {
          enabled = true,
        },
        highlights = {
          enabled = true,
        },
        hover = {
          enabled = true,
          documentation = true,
        },
        links = {
          enabled = true,
        },
        references = {
          enabled = true,
        },
        rename = {
          enabled = true,
        },
        selectionRange = {
          enabled = true,
        },
        signatureHelp = {
          enabled = true,
        },
        workspaceSymbol = {
          enabled = true,
        },
      },
      css = {
        codeActions = {
          enabled = true,
        },
        colors = {
          enabled = true,
          includeFromCurrentDocument = true,
        },
        completion = {
          enabled = true,
        },
        definitions = {
          enabled = true,
        },
        diagnostics = {
          enabled = true,
          lint = {
            enabled = true,
            unknownAtRules = 'ignore',
          },
        },
        documentSymbols = {
          enabled = true,
        },
        foldingRanges = {
          enabled = true,
        },
        highlights = {
          enabled = true,
        },
        hover = {
          enabled = true,
        },
        links = {
          enabled = true,
        },
        rename = {
          enabled = true,
        },
        selectionRange = {
          enabled = true,
        },
        signatureHelp = {
          enabled = true,
        },
        workspaceSymbol = {
          enabled = true,
        },
      },
    },
  },
  capabilities = capabilities,
  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, ctx)
      -- Filter out CSS parser diagnostics that don't understand newer syntax (e.g. if())
      local ignored_codes = {
        ['css-rparentexpected'] = true,
        ['css-termexpected'] = true,
        ['css-lcurlyexpected'] = true,
        ['css-rcurlyexpected'] = true,
        ['css-semicolonexpected'] = true,
        ['css-ruleorselectorexpected'] = true,
      }

      result.diagnostics = vim.tbl_filter(
        function(diagnostic) return not ignored_codes[diagnostic.code] end,
        result.diagnostics
      )

      return vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx)
    end,
  },
}
