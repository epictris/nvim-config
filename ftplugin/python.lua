local format_python = function ()
  local current_file = vim.fn.expand('%:p')
  vim.cmd.w()
  vim.cmd('!ruff check --fix '..current_file)
  vim.cmd('!ruff format '..current_file)
end

vim.keymap.set("n", "<C-f>", format_python)

vim.lsp.start({
  cmd = { "splints" },
  root_dir = vim.fn.getcwd(),
})
