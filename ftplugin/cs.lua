vim.keymap.set("n", "gd", require("omnisharp_extended").telescope_lsp_definition, { desc = "go to definition (C#)"})
vim.keymap.set("n", "gr", require("omnisharp_extended").telescope_lsp_references, { desc = "list references (C#)"})
vim.keymap.set("n", "gt", require("omnisharp_extended").telescope_lsp_type_definition, { desc = "go to type definition (C#)"})
