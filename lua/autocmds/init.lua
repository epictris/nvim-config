vim.api.nvim_create_autocmd('FileType', {
	pattern = 'markdown',
	group = vim.api.nvim_create_augroup('md_only_keymap', { clear = true }),
	callback = function ()
		local buf = vim.api.nvim_get_current_buf()
		local wk = require("which-key")
		wk.register({
			["<C-s>"] = { "<Cmd>VimwikiDiaryPrevDay<CR>", "Next Diary", buffer=buf },
			["<C-e>"] = { "<Cmd>VimwikiDiaryNextDay<CR>", "Next Diary", buffer=buf }
		})
	end
})
