local bin_name = 'marksman'
local cmd = { bin_name, 'server', '--verbose', '0' }
local cmd_env = {
  -- Work around ICU crashes in .NET runtime on newer macOS builds.
  DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = '1',
}

return {
  cmd = cmd,
  cmd_env = cmd_env,
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' },
}
