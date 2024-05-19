return {
	"justinmk/vim-sneak",
	config = function()
		vim.keymap.set({'n', 'v'}, 'f', '<Plug>Sneak_f', {})
		vim.keymap.set({'n', 'v'}, 'F', '<Plug>Sneak_F', {})
		vim.keymap.set({'n', 'v'}, 't', '<Plug>Sneak_t', {})
		vim.keymap.set({'n', 'v'}, 'T', '<Plug>Sneak_T', {})
	end,
}
