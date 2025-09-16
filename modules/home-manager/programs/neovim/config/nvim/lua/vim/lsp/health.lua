local M = {}

function M.check()
  local health = vim.health or require('vim.health')

  -- Log info
  local log_path = vim.lsp.log.get_filename()
  local level = vim.lsp.log.get_level()
  health.info(('Log file: %s'):format(log_path))
  health.info(('Log level: %s'):format(level))

  -- Clients summary
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    health.warn('No LSP clients attached')
    return
  end

  health.ok(('Active LSP clients: %d'):format(#clients))

  for _, client in ipairs(clients) do
    local root = client.config.root_dir or '?'
    local caps = {}

    local sc = client.server_capabilities or {}
    if sc.completionProvider then table.insert(caps, 'completion') end
    if sc.hoverProvider then table.insert(caps, 'hover') end
    if sc.definitionProvider then table.insert(caps, 'definition') end
    if sc.referencesProvider then table.insert(caps, 'references') end
    if sc.documentFormattingProvider then table.insert(caps, 'formatting') end
    if sc.documentRangeFormattingProvider then table.insert(caps, 'range-format') end
    if sc.codeActionProvider then table.insert(caps, 'code-action') end
    if sc.renameProvider then table.insert(caps, 'rename') end
    if sc.signatureHelpProvider then table.insert(caps, 'signature-help') end
    if sc.documentSymbolProvider then table.insert(caps, 'symbols') end

    local msg = ('%s (id=%d, root=%s) caps=[%s]'):format(
      client.name,
      client.id,
      root,
      #caps > 0 and table.concat(caps, ', ') or 'none'
    )

    health.info(msg)
  end
end

return M
