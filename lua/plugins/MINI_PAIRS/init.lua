return {
	"echasnovski/mini.pairs",
	config = function()
		require('mini.pairs').setup({
			modes = { insert = true },
			mappings = {
				['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][$ %)%]}\r\n]'},
				['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][$ %)%]}\r\n]'},
				['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][$ %)%]}\r\n]'},

				[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].'},
				[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].'},
				['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].'},

				['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[\r ][\n ]', register = { bs = false }},
				["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[\r ][\n ]', register = { bs = false }},
				['`'] = { action = 'closeopen', pair = "``", neigh_pattern = '[\r ][\n ]', register = { bs = false }},
			}
		})
	end
}
