local utils = require('utils')
local signs = require('kind').diagnostic_signs
local add = vim.pack.add
local now = Config.now

now(function()
  add({
    'https://github.com/b0o/SchemaStore.nvim.git',
  })
end)

-- Do stuff when an LSP is attached to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Disable color backgrounds for values
    vim.lsp.document_color.enable(false)

    -- display inlay hints
    -- if client and client:supports_method('textDocument/inlayHint') then
    --   vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    -- end

    -- enable completion
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(false, client.id, args.buf, { autotrigger = true })
    end

    -- enable inline completion
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, args.buf) then
      vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
    end

    -- display diagnostics
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
    })
  end,
})

-- Set sign icons
utils.set_sign_icons(signs)

-- Enable Language Servers
local lsp_configs = {}
local ignore_servers = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')

  if not vim.tbl_contains(ignore_servers, server_name) then table.insert(lsp_configs, server_name) end
end

-- C# configuratioo for the roslyn language server, which is used by OmniSharp.
-- Currently unused, but may be useful in the future if I decide to use OmniSharp instead of csharp_ls.
--
-- vim.lsp.config('roslyn', {
--   on_attach = function() print('This will run when the server attaches!') end,
--   settings = {
--     ['csharp|inlay_hints'] = {
--       csharp_enable_inlay_hints_for_implicit_object_creation = true,
--       csharp_enable_inlay_hints_for_implicit_variable_types = true,
--     },
--     ['csharp|code_lens'] = {
--       dotnet_enable_references_code_lens = true,
--     },
--   },
-- })

-- Log levels: "TRACE" | "DEBUG" | "INFO" | "WARN" | "ERROR"
vim.lsp.log.set_level('ERROR')

vim.lsp.enable(lsp_configs)
