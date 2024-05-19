return { 
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		'MunifTanjim/nui.nvim',
	},
	config = function()
		require('noice').setup({
			cmdline = {
				enabled = false
			},
			messages = {
				enabled = false
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				popup = {
					opts = {
						border = {
							style = "rounded",
						}
					}
				},
				hover = {
					enabled = true,
					silent = false,
					view = nil,
					opts = {
						relative = "cursor",
						position = { row = 2, col = 0 },
						size = {
							width = "auto",
							height = "auto",
							max_height = 20,
							max_width = 120,
						},
						border = {
							style = "rounded",
							padding = {0, 0}
						}
					}
				}
			},
		})
		vim.keymap.set("n", "<leader>sm", ":Noice<CR>", {desc="(s)how (m)essages"})
	end
}
