return {
	'nvimdev/lspsaga.nvim',
	config = function()
		require('lspsaga').setup({
			lightbulb = {
				enable = false
			},
			hover = {
				max_width = 0.8,
				max_height = 0.8
			},
			ui = {
					border = 'rounded',
			},
		diagnostic = {
				show_code_action = true,
				diagnostic_only_current = false
			},
		})
	end,
	dependencies = {
		'nvim-treesitter/nvim-treesitter', -- optional
		'nvim-tree/nvim-web-devicons' -- optional
	}
}
