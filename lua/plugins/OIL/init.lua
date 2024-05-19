return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = true,
		view_options = {
			show_hidden = true,
		}
	},
	keys = {
		{ "-" ,
			function()
				require('oil').open()
			end,
			desc= "Open Parent Directory"
		}
	}
}
