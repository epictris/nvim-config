return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		"nvim-telescope/telescope-live-grep-args.nvim",
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},
	config = function ()
		local lga_actions = require('telescope-live-grep-args.actions')
		require('telescope').setup({
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt(),
							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
				}
			}
		})
		pcall(require('telescope').load_extension, 'fzf')
	end
}
