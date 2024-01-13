return {
	"stevearc/dressing.nvim",
	config = function ()
		require("dressing").setup({
		input = {
			prefer_width = 10
		},
		select = {
			backend = {
				'fzf-lua'
			},
		},
		})
	end
}
