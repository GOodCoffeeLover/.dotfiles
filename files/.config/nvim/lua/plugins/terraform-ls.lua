local tf_capb = vim.lsp.protocol.make_client_capabilities()
tf_capb.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig').terraformls.setup({
  on_attach = on_attach,
  flags = { debounce_text_changes = 150 },
  capabilities = tf_capb,
})
vim.api.nvim_create_autocmd({"BufWritePre"}, {

  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

