return {
	"f-person/git-blame.nvim",
	config = function ()
		require("gitblame").setup({
			enabled = true,
		})
		vim.g.gitblame_message_template = '<author> • <date> • <summary>'
		vim.g.gitblame_date_format = '%r: %x'
		vim.g.gitblame_virtual_text_column = 90
		vim.g.gitblame_delay = 0
		vim.keymap.set("n", "<leader>gb", ":GitBlameOpenCommitURL<CR>", { desc = "Open commit hash of current line in Github" })
		vim.keymap.set("n", "<leader>gxf", ":GitBlameCopyFileURL<CR>", { desc = "Copy GitHub url of current file" })
		vim.keymap.set("n", "<leader>gxh", ":GitBlameCopySHA<CR>", { desc = "Copy commit hash of current line" })
	end
}
