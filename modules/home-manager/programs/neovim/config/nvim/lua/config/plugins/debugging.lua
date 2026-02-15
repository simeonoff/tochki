local M = {
  'rcarriga/nvim-dap-ui',

  dependencies = {
    {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
      'leoluz/nvim-dap-go',
    },
  },

  -- Load when opening C# or Go files
  ft = { 'cs', 'go' },
}

function M.init()
  vim.fn.sign_define('DapBreakpoint', {
    text = '■',
    texthl = 'DiagnosticSignError',
    linehl = '',
    numhl = '',
  })

  vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })

  vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'Continue' })

  vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = 'Step Over' })

  vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'Step Into' })

  vim.keymap.set('n', '<leader>dw', function() require('dap.ui.widgets').hover() end, { desc = 'Widgets' })

  vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'Repl' })

  vim.keymap.set('n', '<leader>du', function() require('dapui').toggle({}) end, { desc = 'Dap UI' })

  vim.keymap.set('n', '<leader>dgt', function() require('dap-go').debug_test() end, { desc = 'Debug Go Test' })
end

function M.config()
  local dap, dapui, dapgo = require('dap'), require('dapui'), require('dap-go')

  -- Add CSharp related adapters and configurations
  -- Detect DOTNET_ROOT and netcoredbg path from environment (set by direnv/nix)
  local dotnet_path = vim.fn.exepath('dotnet')
  local netcoredbg_path = vim.fn.exepath('netcoredbg')
  local dotnet_root = nil

  if dotnet_path ~= '' then
    -- Extract the dotnet root from the path (e.g., /nix/store/.../bin/dotnet -> /nix/store/.../share/dotnet)
    local bin_dir = vim.fn.fnamemodify(dotnet_path, ':h')
    local sdk_dir = vim.fn.fnamemodify(bin_dir, ':h')
    dotnet_root = sdk_dir .. '/share/dotnet'
    print(string.format('Detected DOTNET_ROOT: %s', dotnet_root))
  end

  if netcoredbg_path ~= '' then
    print(string.format('Detected netcoredbg: %s', netcoredbg_path))
  else
    print('WARNING: netcoredbg not found in PATH')
  end

  local netcoredbg_adapter = {
    type = 'executable',
    command = netcoredbg_path ~= '' and netcoredbg_path or 'netcoredbg',
    args = { '--interpreter=vscode' },
    options = {
      env = {
        DOTNET_ROOT = dotnet_root,
        PATH = vim.env.PATH,
      },
    },
  }

  dap.adapters.netcoredbg = netcoredbg_adapter
  dap.adapters.coreclr = netcoredbg_adapter

  -- Cache for csproj path during debug session
  local cached_csproj = nil
  local cached_dll = nil
  local cached_cwd = nil

  dap.configurations.cs = {
    {
      type = 'coreclr',
      name = 'Launch - netcoredbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net8.0/', 'file')
      end,
    },
    {
      type = 'coreclr',
      name = 'Launch - Build and Run Project',
      request = 'launch',
      program = function()
        -- Clear cache at start of new debug session
        if cached_csproj and vim.fn.filereadable(cached_csproj) == 0 then
          cached_csproj = nil
          cached_dll = nil
          cached_cwd = nil
        end

        if not cached_csproj then
          cached_csproj = vim.fn.input('Path to csproj: ', vim.fn.getcwd() .. '/', 'file')
          if cached_csproj == '' then
            return nil
          end

          -- Build the project first
          local build_cmd = string.format('dotnet build "%s"', cached_csproj)
          print('\nBuilding project...')
          local result = vim.fn.system(build_cmd)
          if vim.v.shell_error ~= 0 then
            print('\nBuild failed:\n' .. result)
            cached_csproj = nil
            error('Build failed')
          end
          print('Build successful!')

          -- Parse csproj to get assembly name and target framework
          local project_dir = vim.fn.fnamemodify(cached_csproj, ':h')
          local csproj_content = vim.fn.readfile(cached_csproj)
          local assembly_name = vim.fn.fnamemodify(cached_csproj, ':t:r') -- default to csproj filename
          local target_framework = 'net8.0' -- default

          -- Try to extract AssemblyName and TargetFramework from csproj
          for _, line in ipairs(csproj_content) do
            local asm_match = line:match('<AssemblyName>(.-)</AssemblyName>')
            if asm_match then
              assembly_name = asm_match
            end
            local tf_match = line:match('<TargetFramework>(.-)</TargetFramework>')
            if tf_match then
              target_framework = tf_match
            end
          end

          print(string.format('\nParsed project info:'))
          print(string.format('  AssemblyName: %s', assembly_name))
          print(string.format('  TargetFramework: %s', target_framework))
          print(string.format('  Project dir: %s', project_dir))

          -- Construct DLL path
          cached_dll = string.format('%s/bin/Debug/%s/%s.dll', project_dir, target_framework, assembly_name)
          cached_cwd = project_dir

          -- Verify DLL exists
          if vim.fn.filereadable(cached_dll) == 0 then
            print(string.format('\nWARNING: DLL not found at: %s', cached_dll))
            print('You may need to build the project first or check the path.')
          else
            print(string.format('\nFound DLL at: %s', cached_dll))
          end
        end

        return cached_dll
      end,
      cwd = function()
        return cached_cwd or vim.fn.getcwd()
      end,
    },
  }

  -- Clear cache when dap terminates
  dap.listeners.before.event_terminated['clear_csproj_cache'] = function()
    cached_csproj = nil
    cached_dll = nil
    cached_cwd = nil
  end
  dap.listeners.before.event_exited['clear_csproj_cache'] = function()
    cached_csproj = nil
    cached_dll = nil
    cached_cwd = nil
  end

  --- @diagnostic disable: missing-fields
  dapui.setup({
    layouts = {
      {
        -- You can change the order of elements in the sidebar
        elements = {
          -- Provide IDs as strings or tables with "id" and "size" keys
          {
            id = 'scopes',
            size = 0.25, -- Can be float or integer > 1
          },
          { id = 'breakpoints', size = 0.25 },
          { id = 'stacks', size = 0.25 },
          { id = 'watches', size = 0.25 },
        },
        size = 40,
        position = 'right', -- Can be "left" or "right"
      },
      {
        elements = {
          'repl',
        },
        size = 10,
        position = 'bottom', -- Can be "bottom" or "top"
      },
    },
  })
  dapgo.setup()

  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
end

return M
