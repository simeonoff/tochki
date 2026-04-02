return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  workspace_required = true,
  root_markers = { { 'tsconfig.json', 'jsconfig.json' }, 'package.json', '.git' },
  single_file_support = true,
}
