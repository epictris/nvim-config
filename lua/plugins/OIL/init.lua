return {
	'stevearc/oil.nvim',
	-- dir= "~/projects/oil",
	opts = {},
	  -- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require('oil')
		oil.setup({
			default_file_explorer = false,
			cleanup_delay_ms = 0,
			delete_to_trash = true,
			skip_confirm_for_files = true,
			view_options = {
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, "..")
				end
			}
		})
		vim.keymap.set('n', '-',
			function()
				oil.open()
				require('oil.util').run_after_load(0, function()
					oil.open_preview()
				end)
			end,
			{ desc = "Open Parent Directory" }
		)
	end,
}
