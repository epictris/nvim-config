return {
	"echasnovski/mini.operators",
	config = function ()
		require 'mini.operators'.setup({
			exchange = {
				prefix = 'cx'
			},
			replace = {
				prefix = '<leader>r'
			}
		})
	end
}
