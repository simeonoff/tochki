---@brief
---
--- https://ast-grep.github.io/
---
--- ast-grep(sg) is a fast and polyglot tool for code structural search, lint, rewriting at large scale.
--- ast-grep LSP only works in projects that have `sgconfig.y[a]ml` in their root directories.

---@type vim.lsp.Config
return {
  -- `cmd` as a function receives the fully-resolved `config` (including
  -- `root_dir`) right before the process is spawned — the only reliable way to
  -- set the working directory per-root in Neovim's built-in LSP system:
  --   • `cmd_cwd` is NOT derived from `root_dir` automatically
  --     (client.lua: "Not related to root_dir. default: cwd")
  --   • `on_new_config` is an nvim-lspconfig concept — silently ignored here
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'ast-grep', 'lsp' }, dispatchers, {
      cwd = config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  workspace_required = true,
  -- Spawn a separate ast-grep instance per sgconfig.yml root.
  reuse_client = function(client, config) return client.config.root_dir == config.root_dir end,
  -- sgconfig markers first: ast-grep's authoritative anchor. vim.fs.root picks
  -- the *closest* directory containing any marker, so packages/theming/ (which
  -- has sgconfig.yml) wins over the monorepo root (which only has package.json).
  root_markers = { 'sgconfig.yml', 'sgconfig.yaml' },
  filetypes = { -- https://ast-grep.github.io/reference/languages.html
    'bash',
    'c',
    'cpp',
    'cs',
    'css',
    'scss',
    'elixir',
    'go',
    'haskell',
    'html',
    'java',
    'javascript',
    'javascriptreact',
    'json',
    'kotlin',
    'lua',
    'nix',
    'php',
    'python',
    'ruby',
    'rust',
    'scala',
    'solidity',
    'swift',
    'typescript',
    'typescriptreact',
    'yaml',
  },
}
