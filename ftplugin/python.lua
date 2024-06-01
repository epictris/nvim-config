local format_python = function ()
  local current_file = vim.fn.expand('%:p')
  vim.cmd.w()
  vim.cmd('!python -m ruff --fix '..current_file)
  vim.cmd('!python -m ruff format --fix '..current_file)
end

vim.keymap.set("n", "<C-f>", format_python)
