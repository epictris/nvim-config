return {
	"j-morano/buffer_manager.nvim",
	lazy = false,
	priority = 1000,
	config = function ()
		vim.keymap.set('n', '<leader>B', require("buffer_manager.ui").toggle_quick_menu)
	end
}
