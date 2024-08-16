local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
  "n",
  "<leader>ca",
  function()
    vim.cmd.RustLsp('codeAction')
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n",
  "K",
  function()
    vim.cmd.RustLsp({ 'hover' , 'actions'})
  end,
  { silent = false, buffer = bufnr }
)

vim.keymap.set(
  "n",
  "<leader>rd",
  function()
    vim.cmd.RustLsp('renderDiagnostic') -- defaults to 'cycle'
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n",
  "<leader>od",
  function()
    vim.cmd.RustLsp('openDocs')
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n",
  "<leader>oc",
  function()
    vim.cmd.RustLsp('openCargo')
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
    "n",
    "<leader>rs",
    function()
        vim.cmd.RustLsp({'workspaceSymbol', 'allSymbols'})
    end,
    { silent = true, buffer = bufnr }
)

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
vim.keymap.set({ "n" }, "<leader>K", vim.lsp.buf.signature_help, { buffer = bufnr })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.lsp.inlay_hint.enable(true, { bufnr=bufnr })
