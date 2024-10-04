local nmap = function(keys, func, desc)
	if desc then
desc = desc
	end
	vim.keymap.set('n', keys, func, { desc = desc })
end

nmap("<leader>tn", "gt", "next tab")
nmap("<leader>tl", "gT", "last tab")
nmap("<C-t>", "<C-w>k", "focus above window")
nmap("<C-n>", "<C-w>j", "focus below window")
nmap("<leader>cx", ":!chmod +x %<CR>", "make file executable")

