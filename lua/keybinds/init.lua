local nmap = function(keys, func, desc)
	if desc then
desc = desc
	end
	vim.keymap.set('n', keys, func, { desc = desc })
end

local telescope = require('telescope.builtin')
local picker = require('telescope.themes').get_dropdown

vim.keymap.set('n', 'q', '<Ignore>')
vim.keymap.set('n', 'qq', 'q')

-- Buffer Navigation
nmap('<leader>sb', function() telescope.buffers(picker({})) end, 'Session buffers')

-- File Navigation
nmap("<leader>nt", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, "(n)avigate (t)his directory")
nmap("<leader>nr", function() MiniFiles.open(nil, false) end, "(n)avigate (r)oot directory")
nmap("<leader>ft", function() telescope.find_files(picker({ cwd = vim.fn.expand('%:h') })) end, "(f)iles in (t)his directory")
nmap("<leader>fr", function() telescope.find_files(picker({})) end, "(f)iles in (r)oot directory")
nmap("<leader>fo", function() telescope.oldfiles(picker({})) end, "(f)iles in (o)ldfiles list")

-- Text Search
nmap("<leader>sr", function() telescope.live_grep(picker({})) end, "(s)earch text in (r)oot directory")
nmap("<leader>st", function() telescope.live_grep(picker({ cwd = vim.fn.expand('%:h') })) end, "(s)earch text in (r)oot directory")
nmap("<leader>sw", function() telescope.grep_string(picker({})) end, "(s)earch for (w)ord under cursor in root directory")

-- Git
nmap("<leader>gs", function() telescope.git_stash(picker({})) end, "Git stash")
nmap("<leader>gd", function() telescope.git_status(picker({})) end, "Changed files")

-- LSP
nmap("gd", function() telescope.lsp_definitions(picker({})) end, "(g)o to (d)efinition")
nmap("gr", function() telescope.lsp_references(picker({})) end, "(g)o to (r)eferences")
nmap("gt", function() telescope.lsp_type_definitions(picker({})) end, "(g)o to (t)ype defintion")


vim.api.nvim_set_hl(0, 'VimwikiHeader1', { link = "CmpItemKindText" })
vim.api.nvim_set_hl(0, 'VimwikiHeader2', { link = "CmpItemKindInterface" })
vim.api.nvim_set_hl(0, 'VimwikiHeader3', { link = "CmpItemAbbrMatchFuzzy" })


nmap("<leader>tn", "gt", "next tab")
nmap("<leader>tl", "gT", "last tab")
nmap("<C-t>", "<C-w>k", "focus above window")
nmap("<C-n>", "<C-w>j", "focus below window")


