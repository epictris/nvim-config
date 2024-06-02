return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		-- Adds textobjects based on treesitter parsing
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
	config = function ()
---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup {
			textobjects = {
				select = {
					enable = false,
				},
				move = {
					enable = false
				},
				swap = {
					enable = false,
				}
			},
			ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
				'markdown', 'markdown_inline', 'cmake' , 'bash'},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				lookahead = true,
				keymaps = {
					init_selection = false,
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
		}
	end
}
