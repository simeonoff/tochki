-- https://github.com/mdx-js/mdx-analyzer
-- Language server for MDX. Wraps TypeScript's language service with MDX
-- awareness: component prop completions, type errors, go-to-definition, etc.

local utils = require('utils')

local function get_probe_dir(dir)
  if not dir or dir == '' then return '' end

  local project_root = utils.root_pattern({ 'node_modules' }, dir)
  local tsdk = project_root and (project_root .. '/node_modules/typescript/lib') or ''

  if tsdk ~= '' and vim.uv.fs_stat(tsdk) then return tsdk end
  return ''
end

return {
  cmd = { 'mdx-language-server', '--stdio' },
  filetypes = { 'mdx' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  -- Disable dynamic file-watcher registration: mdx-language-server sends a
  -- **/*.{mdx} glob pattern that Neovim's glob parser rejects (no brace expansion).
  capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false,
      },
    },
  }),
  before_init = function(params, config)
    local tsdk = get_probe_dir(config.root_dir)

    params.initializationOptions = vim.tbl_deep_extend('force', params.initializationOptions or {}, {
      typescript = {
        enabled = true,
        tsdk = tsdk,
      },
    })
  end,
  workspace_required = true,
}
