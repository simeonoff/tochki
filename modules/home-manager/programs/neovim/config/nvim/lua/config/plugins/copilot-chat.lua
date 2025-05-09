local M = {
  'CopilotC-Nvim/CopilotChat.nvim',
  event = 'VeryLazy',
  command = 'CopilotChat',
  dependencies = {
    { 'zbirenbaum/copilot.lua' },
    { 'nvim-lua/plenary.nvim' }, -- for curl, log and async functions
  },
  keys = {
    { '<leader>cc', '<cmd>CopilotChat<cr>', desc = 'Open Copilot Chat interface' },
  },
  init = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'copilot-*',
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.conceallevel = 0
      end,
    })
  end,
  build = 'make tiktoken', -- Only on MacOS or Linux
}

M.config = function()
  require('CopilotChat').setup({
    prompts = {
      Wiki = {
        prompt = 'Answer the question as if you were a succinct Wikipedia article.',
        system_prompt = 'You are a helpful assistant that provides information in a concise and informative manner.',
        description = 'My prompt for general questions.',
      },
    },
  })
end

return M
