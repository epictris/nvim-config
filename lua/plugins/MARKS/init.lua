return {
	"chentoast/marks.nvim",
	config = function()
		require("marks").setup({
			mappings = {
				next = "gn",
				prev = "gl",
			}
		})
		vim.keymap.set('n', '<leader>mg', '<cmd>MarksListGlobal<cr>')
		vim.keymap.set('n', '<leader>mb', '<cmd>MarksListBuf<cr>')
	end,
}
