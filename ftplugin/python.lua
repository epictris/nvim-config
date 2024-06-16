local format_python = function ()
  local current_file = vim.fn.expand('%:p')
  vim.cmd.w()
  vim.cmd('!ruff --fix '..current_file)
  vim.cmd('!ruff format '..current_file)
end

vim.keymap.set("n", "<C-f>", format_python)
