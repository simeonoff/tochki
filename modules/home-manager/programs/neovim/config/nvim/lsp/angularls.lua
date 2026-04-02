local utils = require('utils')

local function get_probe_dir(dir)
  local project_root = utils.root_pattern({ 'node_modules' }, dir)
  return project_root and (project_root .. '/node_modules') or ''
end

local function get_angular_core_version(dir)
  local project_root = utils.root_pattern({ 'node_modules' }, dir)

  if not project_root then return '' end

  local package_json = project_root .. '/package.json'
  if not vim.uv.fs_stat(package_json) then return '' end

  local file = io.open(package_json, 'r')
  if not file then return '' end

  local contents = file:read('*a')
  file:close()
  if not contents then return '' end

  local ok, json = pcall(vim.json.decode, contents)
  if not ok or type(json) ~= 'table' then return '' end

  local angular_core_version = (json.dependencies or {})['@angular/core']
    or (json.devDependencies or {})['@angular/core']
    or ''

  return angular_core_version:match('%d+%.%d+%.%d+') or ''
end

local function build_cmd(dir)
  local probe_dir = get_probe_dir(dir)
  local angular_core_version = get_angular_core_version(dir)

  local cmd = {
    'ngserver',
    '--stdio',
    '--tsProbeLocations',
    probe_dir,
    '--ngProbeLocations',
    probe_dir,
  }

  if angular_core_version ~= '' then
    table.insert(cmd, '--angularCoreVersion')
    table.insert(cmd, angular_core_version)
  end

  return cmd
end

return {
  cmd = build_cmd(vim.fn.getcwd()),
  filetypes = { 'typescript', 'html', 'htmlangular' },
  root_markers = { 'angular.json', 'nx.json' },
  workspace_required = true,
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = build_cmd(new_root_dir or vim.fn.getcwd())
  end,
}
