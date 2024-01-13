return {
	'echasnovski/mini.files',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function ()
		require('mini.files').setup()
	end
}
