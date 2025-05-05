local M = {
  'nvim-plugins/1password.nvim',
  event = 'VeryLazy',
  name = '1password.nvim',
  dev = true,
  enabled = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
}

M.config = function() require('1password').setup({}) end

return M
