return {
	'ThePrimeagen/harpoon',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function ()
		local buffer_width = vim.api.nvim_win_get_width(0)
		local menu_width = (buffer_width < 120 and buffer_width or 120) - 20
		require("harpoon").setup({
			menu = {
				width = menu_width
			}
		})
		-- File Marks
		vim.keymap.set("n", "<leader>m", require("harpoon.mark").add_file, {desc="Mark file"})
		vim.keymap.set("n", "<leader>M", require("harpoon.ui").toggle_quick_menu, {desc="View marked files"})
		vim.keymap.set("n", "<leader>1", (function() require("harpoon.ui").nav_file(1) end), {desc="Go to mark 1"})
		vim.keymap.set("n", "<leader>2", (function() require("harpoon.ui").nav_file(2) end), {desc="Go to mark 2"})
		vim.keymap.set("n", "<leader>3", (function() require("harpoon.ui").nav_file(3) end), {desc="Go to mark 3"})
		vim.keymap.set("n", "<leader>4", (function() require("harpoon.ui").nav_file(4) end), {desc="Go to mark 4"})
		vim.keymap.set("n", "<leader>5", (function() require("harpoon.ui").nav_file(4) end), {desc="Go to mark 5"})
	end
}
