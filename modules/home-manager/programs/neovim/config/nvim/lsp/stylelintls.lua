return {
  cmd = { 'stylelint-lsp', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'less',
    'scss',
    'sugarss',
    'vue',
    'wxss',
  },
  root_markers = {
    '.stylelintrc',
    '.stylelintrc.mjs',
    '.stylelintrc.cjs',
    '.stylelintrc.js',
    '.stylelintrc.json',
    '.stylelintrc.yaml',
    '.stylelintrc.yml',
    'stylelint.config.mjs',
    'stylelint.config.cjs',
    'stylelint.config.js',
  },
  settings = {
    autoFixOnFormat = true,
  },
}
