return {
	"echasnovski/mini.hipatterns",
	config = function ()
		local hipatterns = require('mini.hipatterns')
		hipatterns.setup({
			highlighters = {
				priority = { pattern = 'PRIORITY', group = 'DiagnosticSignWarn' },
				blocked = { pattern = 'BLOCKED.*', group = 'DiagnosticSignError' },
				paused = { pattern = 'PAUSED', group = 'DiagnosticSignHint' },
			},

			hex_color = hipatterns.gen_highlighter.hex_color(),
		})
	end
}
