return {
  'cbochs/grapple.nvim',
  event = 'User VeryLazy',
  dependencies = { 'nvim-web-devicons' },
  keys = {
    { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
    { '<c-a-p>', '<cmd>Grapple cycle backward<cr>', desc = 'Go to previous tag' },
    { '<c-a-n>', '<cmd>Grapple cycle forward<cr>', desc = 'Go to next tag' },
  },
  opts = {
    scope = 'git_branch',
    icons = true,
    status = false,
  },
}
