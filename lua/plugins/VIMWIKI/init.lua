vim.g.vimwiki_list = {
	{ path = '~/wiki_unc/', syntax = 'markdown', ext = 'md' },
	{ path = '~/wiki_personal/', syntax = 'markdown', ext = 'md' }
}
vim.g.vimwiki_markdown_link_ext = 1
vim.g.vimwiki_automatic_nested_syntaxes = 1
vim.g.vimwiki_listsyms_propagate = 0
local function filename_to_date(file_name)
	local year, month, day = table.unpack(vim.split(file_name, "-"))
	local timestamp = os.time({ year = year, month = month, day = day, hour = 12 })
	return os.date("%A %d %B %Y", timestamp)
end

local function make_diary_note()
	vim.cmd("call vimwiki#diary#make_note(v:count, 5)")
	local wiki_dir = vim.fn.expand("%:p:h")
	vim.fn.chdir(wiki_dir)
	if vim.api.nvim_buf_line_count(0) == 1 then
		local file_name = vim.fn.expand("%:t:r")
		local date_header = "# "..filename_to_date(file_name)
		vim.api.nvim_buf_set_lines(0, 0, 0, false, {date_header})
	end
end

local function open_wiki_index()
	vim.cmd("call vimwiki#base#goto_index(v:count)")
	local wiki_dir = vim.fn.expand("%:p:h")
	vim.fn.chdir(wiki_dir)
end

return {
	"vimwiki/vimwiki",
	config = function ()
		vim.keymap.set('n', '<leader>w<leader>w', make_diary_note, {remap = false})
		vim.keymap.set('n', '<leader>ww', open_wiki_index, {remap = false})
	end
}
