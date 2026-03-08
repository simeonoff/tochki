local add = vim.pack.add
local later = Config.later
local map = vim.keymap.set

later(function()
  add({
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/igorlfs/nvim-dap-view',
  })

  local dap = require('dap')
  local dap_view = require('dap-view')

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = {
        vim.env.VSCODE_JS_DEBUG_PATH,
        '${port}',
      },
    },
  }

  dap.configurations.javascript = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
    },
  }

  vim.fn.sign_define('DapBreakpoint', {
    text = '■',
    texthl = 'DiagnosticSignError',
    linehl = '',
    numhl = '',
  })

  -- DAP Mappings
  map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
  map('n', '<leader>dc', dap.continue, { desc = 'Continue' })
  map('n', '<leader>do', dap.step_over, { desc = 'Step Over' })
  map('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
  map('n', '<leader>dr', dap.repl.open, { desc = 'Repl' })
  map('n', '<leader>du', dap_view.toggle, { desc = 'Dap UI' })

  dap.listeners.after.event_initialized['dapui_config'] = dap_view.open
  dap.listeners.before.event_terminated['dapui_config'] = dap_view.close
end)
