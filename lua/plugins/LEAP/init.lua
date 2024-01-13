return {
	'ggandor/leap.nvim',
	opts = {
		safe_labels = {}
	},
	config = function()
			vim.keymap.set("n", "s", function()
			local current_window = vim.fn.win_getid()
			require('leap').leap { target_windows = { current_window }}
		end)
	end
}
