local format_typescriptreact = function ()
    local current_file = vim.fn.expand('%:p')
    vim.cmd.w()
    vim.cmd.cd("main/site")
    vim.cmd('!npx biome format --write --config-path ../.. '..current_file)
    vim.cmd.cd("../..")
end

vim.keymap.set("n", "<C-f>", format_typescriptreact)
